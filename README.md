# EmojiPickerViewController

A picker view controller for emoji.

<p align="center">
  <img src="https://raw.githubusercontent.com/yosshi4486/EmojiPickerViewController/main/samplegif_iphone.gif" alt="iPhone Example" />
  <img src="https://raw.githubusercontent.com/yosshi4486/EmojiPickerViewController/main/samplegif_ipad.gif" alt="iPad Example" />
</p>

## Features

-   [x] [UTS#51 Specification](https://unicode.org/reports/tr51/)-compliant Emoji Picker(Not Tested Yet)
-   [x] Segmented control for jumping an emoji section
-   [x] Search bar and search results
-   [x] Fully accessible
-   [x] Dark mode
-   [x] Recently used
-   [ ] Select skin tones from popup
-   [ ] State Restoration

## Usage

```swift

import EmojiPickerViewController

// Specifying the maximum storage amount for recently used emoji.
EmojiContainer.main.storageAmountForRecentlyUsedEmoji = 30

var configuration = EmojiPickerConfiguration()

// Enabling animation changes.
configuration.animatingChanges = true

// Specifying the maximum number of recently used emojis.
configuration.numberOfItemsInRecentlyUsedSection = 30

// Changing header appearance.
configuration.headerAppearance.textAlignment = .center

// Changing cell appearance.
configuration.cellAppearance.size = .init(width: 30, height: 30)

let emojiPickerViewController = EmojiPickerViewController(configuration: configuration)

// Receiving events from the picker view controller.
emojiPickerViewController.delegate = self

vc.present(emojiPickerViewController, animated: true)

```

You can specify the annotation's locale manually:

```swift
if EmojiLocale.availableIdentifiers.contains("ja") {
    EmojiContainer.main.emojiLocale = EmojiLocale(localeIdentifier: "ja")!
}
```

or enable an automatic update option:

```swift
configuration.automaticallyUpdatingAnnotationsFollowingCurrentInputModeChange = true

// Disable
// configuration.automaticallyUpdatingAnnotationsFollowingCurrentInputModeChange = false
```

The option is `true` by default.

You can get an `Emoji` object by accessing a singleton `EmojiContainer` instance if you need them:

```swift
let bouncingBall = EmojiContainer.main.entireEmojiSet["⛹🏿‍♀"]!
print(bouncingBall)
// Prints "character: ⛹🏿‍♀, status: minimallyQualified, group: People & Body, subgroup: person-sport, cldrOrder: 2360, annotation: ball | dark skin tone | woman | woman bouncing ball, textToSpeech: woman bouncing ball: dark skin tone"

let grape = EmojiContainer.main.labeledEmojisForKeyboard[.foodDrink]![0]
print(grape)
// Prints "character: 🍇, status: fullyQualified, group: Food & Drink, subgroup: food-fruit, cldrOrder: 3323, annotation: fruit | grape | grapes, textToSpeech: grapes"
```

See and run [Example](./Example/) for checking usages.

## Installation

Install this package via swift package manager. Add EmojiPickerViewController as a dependency to your `Package.swift`:

`.package(url: "https://github.com/yosshi4486/EmojiPickerViewController", from: "1.0.0")`

### Requirement

-   iOS 15.0+
-   Xcode 13.0+

## Localizations

### For User Interfaces

en, ja, da

### For Annotations

`EmojiLocale.availableIdentifiers`

## Contribution

I'm looking forward for your issues or pull requests😊

Proofreading is specifically welcome because I'm not a native English speaker, and some sentences may be strange.

## Licence

EmojiPickerViewController is released under the Apache License Version 2.0, and also uses some licensed OSSs such as "unicode-org/cldr". See [LICENSE](./LICENSE) for details.
