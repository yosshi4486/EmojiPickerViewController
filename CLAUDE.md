# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

EmojiPickerViewController is a Swift Package Manager library that provides a customizable emoji picker UI component for Apple platforms (iOS 15+, tvOS 15+, watchOS 8+, macOS 12+). The library follows the UTS#51 Unicode specification and includes features like search, dark mode, accessibility, and recently used emojis.

## Development Commands

```bash
# Build the package
swift build -v

# Run all tests
swift test -v

# Run a specific test
swift test --filter TestClassName
```

## Architecture

### Core Components

- **EmojiContainer**: Singleton that manages the entire emoji dataset, including loading CLDR annotations and handling recently used emojis. Access via `EmojiContainer.main`.

- **EmojiPickerViewController**: Main view controller that presents the emoji picker interface. Configured via `EmojiPickerConfiguration`.

- **Data Flow**: 
  - CLDR XML files → AnnotationLoader → EmojiContainer → EmojiPickerViewController
  - User interactions update the recently used emojis stored in UserDefaults

### Key Design Decisions

- **MainActor Design**: The entire library adopts MainActor for concurrency. This simplifies the codebase since there are no lengthy operations (load time is max ~0.1 seconds).

- **Localization**: Annotations are loaded from CLDR XML files based on the current locale or can be manually set via `EmojiContainer.main.emojiLocale`.

## Testing Approach

The project uses XCTest with tests organized by component:
- Model tests (Emoji, EmojiContainer)
- Annotation loader tests
- Configuration tests
- Localization tests

## Dependencies

- `SwiftyXMLParser` (5.6.0+): For parsing CLDR emoji annotation XML files
- `swift-collections` (1.1.0+): For advanced collection types used in emoji organization

## Development Workflow

When implementing features or fixes, create git commits after completing each logical unit of work. This helps maintain a clear history and makes it easier to track changes.