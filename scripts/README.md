# Scripts

This directory contains automation scripts for maintaining the EmojiPickerViewController project.

## update-emoji-resources.sh

Automatically downloads and updates emoji resources from official Unicode sources.

### Usage

```bash
# From the project root directory
./scripts/update-emoji-resources.sh
```

### What it does

1. **Downloads emoji-test.txt** from Unicode.org (currently version 16.0)
2. **Downloads CLDR annotation files** from the unicode-org/cldr repository
3. **Downloads CLDR annotationsDerived files** from the unicode-org/cldr repository (with `_derived` suffix)
4. **Updates README.md** with the new version information

### Features

- ✅ Progress reporting during downloads
- ✅ File validation (checks for valid XML format)
- ✅ Automatic file naming for Swift Package compatibility (adds `_derived` suffix to annotationsDerived files)
- ✅ Cross-platform compatibility (macOS, Linux)
- ✅ Safe error handling
- ✅ Colored output for better readability

### Requirements

- `curl` (for downloading files)
- `git` (for project operations)
- `python3` or `grep`+`sed` (for JSON parsing)

### After running

1. **Test the application** to ensure new resources work correctly
2. **Run the tests** with `swift test` (some test failures are expected due to emoji count changes)
3. **Commit the changes** to version control

### Important Notes

- **File naming**: The script automatically adds `_derived` suffix to files in the annotationsDerived directory to avoid naming conflicts with Swift Package Manager
- **No backup**: The script does not create backups. Use version control to revert if needed

### Troubleshooting

If the script fails:
- Check your internet connection
- Verify that Unicode.org and GitHub are accessible
- Use git to revert changes if needed

The script is designed to be run occasionally when Unicode releases new emoji versions, not for continuous integration.