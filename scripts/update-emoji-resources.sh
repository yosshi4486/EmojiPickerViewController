#!/bin/bash

# Update Emoji Resources Script
# Automatically downloads the latest emoji-test.txt and CLDR annotation files
# from official Unicode sources and updates the project resources.

set -e  # Exit on any error

# Configuration
EMOJI_VERSION="16.0"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
RESOURCES_DIR="$PROJECT_ROOT/Sources/EmojiPickerViewController/Resources"

# URLs
EMOJI_TEST_URL="https://www.unicode.org/Public/emoji/${EMOJI_VERSION}/emoji-test.txt"
CLDR_ANNOTATIONS_BASE_URL="https://raw.githubusercontent.com/unicode-org/cldr/main/common/annotations"
CLDR_ANNOTATIONS_DERIVED_BASE_URL="https://raw.githubusercontent.com/unicode-org/cldr/main/common/annotationsDerived"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if required tools are available
check_dependencies() {
    log_info "Checking dependencies..."
    
    if ! command -v curl &> /dev/null; then
        log_error "curl is required but not installed."
        exit 1
    fi
    
    if ! command -v git &> /dev/null; then
        log_error "git is required but not installed."
        exit 1
    fi
    
    log_success "All dependencies are available."
}


# Download emoji-test.txt
download_emoji_test() {
    log_info "Downloading emoji-test.txt version $EMOJI_VERSION..."
    
    local temp_file=$(mktemp)
    
    if curl -L --fail --silent --show-error -o "$temp_file" "$EMOJI_TEST_URL"; then
        # Verify the file has reasonable content
        local line_count=$(wc -l < "$temp_file")
        if [ "$line_count" -gt 100 ]; then
            mv "$temp_file" "$RESOURCES_DIR/emoji-test.txt"
            log_success "Downloaded emoji-test.txt ($line_count lines)"
        else
            log_error "Downloaded emoji-test.txt appears to be invalid (only $line_count lines)"
            rm -f "$temp_file"
            return 1
        fi
    else
        log_error "Failed to download emoji-test.txt from $EMOJI_TEST_URL"
        rm -f "$temp_file"
        return 1
    fi
}

# Get list of annotation files from CLDR repository
get_cldr_file_list() {
    local type="$1"  # "annotations" or "annotationsDerived"
    log_info "Getting list of CLDR $type files..."
    
    # Use GitHub API to get the file list
    local api_url="https://api.github.com/repos/unicode-org/cldr/contents/common/$type"
    local temp_json=$(mktemp)
    
    if curl -L --fail --silent --show-error -o "$temp_json" "$api_url"; then
        # Extract .xml filenames from JSON response
        if command -v python3 &> /dev/null; then
            python3 -c "
import json
import sys
try:
    with open('$temp_json', 'r') as f:
        data = json.load(f)
    for item in data:
        if item.get('name', '').endswith('.xml') and item.get('type') == 'file':
            print(item['name'])
except Exception as e:
    sys.exit(1)
"
        elif command -v grep &> /dev/null && command -v sed &> /dev/null; then
            # Fallback using grep and sed
            grep '"name":' "$temp_json" | grep '\.xml"' | sed 's/.*"name": *"\([^"]*\)".*/\1/'
        else
            log_error "Need either python3 or grep+sed to parse JSON"
            rm -f "$temp_json"
            return 1
        fi
        rm -f "$temp_json"
    else
        log_error "Failed to get file list for $type"
        rm -f "$temp_json"
        return 1
    fi
}

# Download CLDR annotation files
download_cldr_files() {
    local type="$1"  # "annotations" or "annotationsDerived"
    local base_url="$2"
    local target_dir="$RESOURCES_DIR/CLDR/$type"
    
    log_info "Downloading CLDR $type files..."
    
    # Ensure target directory exists
    mkdir -p "$target_dir"
    
    # Get file list
    local file_list=$(get_cldr_file_list "$type")
    if [ -z "$file_list" ]; then
        log_error "Could not retrieve file list for $type"
        return 1
    fi
    
    local count=0
    local total=$(echo "$file_list" | wc -l)
    
    while IFS= read -r filename; do
        if [ -n "$filename" ]; then
            count=$((count + 1))
            log_info "[$count/$total] Downloading $filename..."
            
            local file_url="$base_url/$filename"
            local temp_file=$(mktemp)
            
            if curl -L --fail --silent --show-error -o "$temp_file" "$file_url"; then
                # Basic validation - check if it's a valid XML file
                if head -1 "$temp_file" | grep -q "<?xml"; then
                    # For annotationsDerived, add _derived suffix to avoid name conflicts
                    if [ "$type" = "annotationsDerived" ]; then
                        # Transform filename: en.xml -> en_derived.xml
                        local target_filename="${filename%.xml}_derived.xml"
                        mv "$temp_file" "$target_dir/$target_filename"
                    else
                        # Keep original filename for annotations
                        mv "$temp_file" "$target_dir/$filename"
                    fi
                else
                    log_warning "Downloaded $filename doesn't appear to be valid XML, skipping..."
                    rm -f "$temp_file"
                fi
            else
                log_warning "Failed to download $filename, skipping..."
                rm -f "$temp_file"
            fi
        fi
    done <<< "$file_list"
    
    log_success "Downloaded $type files to $target_dir"
}

# Update README.md with new version information
update_readme() {
    log_info "Updating README.md with new version information..."
    
    local readme_file="$RESOURCES_DIR/README.md"
    
    if [ -f "$readme_file" ]; then
        # Update the emoji version references
        sed -i.tmp "s/Emoji [0-9]\+\.[0-9]\+/Emoji $EMOJI_VERSION/g" "$readme_file"
        sed -i.tmp "s|emoji/[0-9]\+\.[0-9]\+/|emoji/$EMOJI_VERSION/|g" "$readme_file"
        
        # Clean up temporary file
        rm -f "$readme_file.tmp"
        
        log_success "Updated README.md with Emoji $EMOJI_VERSION information"
    else
        log_warning "README.md not found at $readme_file"
    fi
}


# Main execution
main() {
    log_info "Starting emoji resources update process..."
    log_info "Target emoji version: $EMOJI_VERSION"
    log_info "Resources directory: $RESOURCES_DIR"
    
    # Check dependencies
    check_dependencies
    
    # Verify resources directory exists
    if [ ! -d "$RESOURCES_DIR" ]; then
        log_error "Resources directory not found: $RESOURCES_DIR"
        log_error "Please run this script from the project root or verify the project structure."
        exit 1
    fi
    
    # Download emoji-test.txt
    if ! download_emoji_test; then
        log_error "Failed to download emoji-test.txt"
        exit 1
    fi
    
    # Download CLDR annotations
    if ! download_cldr_files "annotations" "$CLDR_ANNOTATIONS_BASE_URL"; then
        log_error "Failed to download CLDR annotations"
        exit 1
    fi
    
    # Download CLDR annotationsDerived
    if ! download_cldr_files "annotationsDerived" "$CLDR_ANNOTATIONS_DERIVED_BASE_URL"; then
        log_error "Failed to download CLDR annotationsDerived"
        exit 1
    fi
    
    # Update README.md
    update_readme
    
    log_success "Emoji resources update completed successfully!"
    log_info "Updated to Emoji version: $EMOJI_VERSION"
    log_info ""
    log_info "Next steps:"
    log_info "1. Test the application to ensure the new resources work correctly"
    log_info "2. Run tests with 'swift test' (some failures are expected due to emoji count changes)"
    log_info "3. Commit the changes to version control"
}

# Script entry point
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    main "$@"
fi