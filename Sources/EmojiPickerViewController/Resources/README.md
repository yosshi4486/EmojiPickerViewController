#  Resources
After swift5.3, Swift Packages can have its resource files under the `Sources` directory, it means subdirectry.

The instructions is this: https://developer.apple.com/documentation/swift_packages/bundling_resources_with_a_swift_package

Xcode automatically handles some types bellow:
- Interface Builder files; for example, XIB files and storyboards
- Core Data files; for example, xcdatamodeld files
- Asset catalogs
- .lproj folders you use to provide localized resources

Other resources must be declared in `Package.swift`

## Current Referenced Version
Dev No.40.
https://cldr.unicode.org/index/downloads

Emoji 16.0

# Emoji-text.txt
https://www.unicode.org/Public/emoji/16.0/emoji-test.txt

If you update the unicode emoji's version, the version path should be updated to the version. e.g. https://www.unicode.org/Public/emoji/16.0/emoji-test.txt

## Annotations
All annotation files are located at: https://github.com/unicode-org/cldr/tree/main/common/annotations
All derived annotation files are located at: https://github.com/unicode-org/cldr/tree/main/common/annotationsDerived

## LICENSE
I copied unicode-org/cldr terms-of-uses at `EmojiPickerViewController/LICENSE.md`, and described what the changes are made.

