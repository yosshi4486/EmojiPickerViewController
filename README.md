# EmojiPickerViewController

A picker view controller for emoji.

![iPhone Example](./samplegif_iphone.gif)

![iPad Example](./samplegif_ipad.gif)

## Features

-   [x] Emoji picker following [UTS#51 Specification](https://unicode.org/reports/tr51/)
-   [x] Segmented control for jumping an emoji section
-   [x] Seach bar and search results
-   [x] Fully accessible
-   [x] Dark mode
-   [ ] Recently used
-   [ ] Select skin tones from popup

## Usege

```swift

import EmojiPicker

var configuration = EmojiPickerConfiguration()

// Enabling changes animation.
configuration.animatingChanges = true

// Changing each header appearance.
configuration.headerAppearance.textAlignment = .center

// Changing each cell appeanrance.
configuration.cellAppearance.size = .init(width: 30, height: 30)

let emojiPickerViewController = EmojiPickerViewController

// Receiveing events from the picker view controller.
emojiPicker.delegate = self

```

You can specify the annotation's locale manually:

```swift
if EmojiLocale.availableIdentifiers.contain("ja") {
    EmojiContainer.main.emojiLocale = EmojiLocale(localeIdentifier: "ja")!
}
```

or enable an automatic update option:

```swift
EmojiContainer.main.automaticallyUpdatingAnnotationsFollowingCurrentInputModeChange = true

// Disable
// EmojiContainer.main.automaticallyUpdatingAnnotationsFollowingCurrentInputModeChange = false
```

The option is `true` by default.

You can get an `Emoji` object by accessing a singleton `EmojiContainer` instance if you need them:

```swift
let bouncingBall = EmojiContainer.main.entireEmojiSet["⛹🏿‍♀"]!
print(bouncingBall)
// Prints "character: ⛹🏿‍♀, status: minimallyQualified, group: People & Body, subgroup: person-sport, cldrOrder: 2360, annotation: ball | dark skin tone | woman | woman bouncing ball, textToSpeach: woman bouncing ball: dark skin tone"

let grape = EmojiContainer.main.labeledEmojisForKeyboard["🍇"]!
print(grape)
// Prints "character: 🍇, status: fullyQualified, group: Food & Drink, subgroup: food-fruit, cldrOrder: 3323, annotation: fruit | grape | grapes, textToSpeach: grapes"
```

See and run [Example](./Example/) for checking usages.

## Installation

Install this package from via swift package manager. Add EmojiPickerViewController as a dependency to your `Package.swift`:

`.package(url: "https://github.com/yosshi4486/EmojiPickerViewController", from: "1.0.0")`

### Requirement

-   iOS 15.0+
-   Xcode 13.0+

## Localizations

### For User Interfaces

["en", "ja"]

### For Annotations

`EmojiLocale.availableIdentifiers`

## Contribution

I'm looking forward for your issues or pull requests😊

Proofreading is specifically welcome because I'm not a native English speaker, and some sentences may be strange.

## Licence

EmojiPickerViewController is released under the Apache License Version 2.0, and also uses some licensed OSSs such as "unicode-org/cldr". See [LICENSE](./LICENSE) for details.
