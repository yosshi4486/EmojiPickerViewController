//
//  Emoji.swift
//  
//
//  Created by yosshi4486 on 2022/01/27.
//

import Foundation

/**
 A type that represents `Emoji`.

 # Desining var and let
 To make a fulfilled emoji, we have to load several resources to collect properties of the emoji, so we design Emoji object like below:

 - use `let` if the property is described in `Resources/emoji-test.txt`.
 - use `var`with the default value  if the property is not described in `Resources/emoji-test.txt`.

 We can make all property changes to `let` by making a combined resource of all resources, but it may make other complications.
*/
public final class Emoji {

    /**
     The character representation of the emoji.
     */
    let character: Character

    /**
     The group name where the emoji belongs. This property is set following `Resources/emoji-test.txt`. Ex.) Smileys & Emotion, People & Body
     */
    let group: String

    /**
     The subgroup name where the emoji belongs. This property is set following `Resources/emoji-test.txt`. Ex.) face-smiling, hand-fingers-open
     */
    let subgroup: String

    /**
     The recommended emoji order which CLDR provides.  The emojis in `Resources/emoji-test.txt` are following CLDR order.

     The default value is `0`, however an actual value will be set later.
     */
    var recommendedOrder: UInt = 0

    /**
     The primay label of the emoji. This property is set following `Resources/labels.txt`. Ex.) Smileys & People, Animals & Nature.

     The default value is empty, however an actual value will be set later.
     */
    var primaryLabel: String = ""

    /**
     The secondary label of the emoji. This property is set following `Resources/labels.txt`. Ex.) transport-ground, food-prepared.

     The default value is empty, however an actual value will be set later.
     */
    var secondaryLabel: String = ""

    /**
     The annotations for searching emojis. The value includes multiple annotations which are separated by vertical line "|",  such as `face | geek | nerd`.  This property is set following`Resources/CLDR/annotations` and `Resources/CLDR/annotationsDerived` .

     This property can be replaced when the keyboard's primary language is changed. The default value is empty, however an actual value will be set later.

     - SeeAlso: [UITextInputMode.currentInputModeDidChangeNotification](https://developer.apple.com/documentation/uikit/uitextinputmode/1614517-currentinputmodedidchangenotific)
     */
    var annotations: String = ""

    /**
     The tts value for screen reader functionality. In Apple Platform, the value should be read by VoiceOver. This property is set following`Resources/CLDR/annotations` and `Resources/CLDR/annotationsDerived`

     This property can be replaced when the keyboard's primary language is changed. The default value is empty, however an actual value will be set later.

     - SeeAlso: [UITextInputMode.currentInputModeDidChangeNotification](https://developer.apple.com/documentation/uikit/uitextinputmode/1614517-currentinputmodedidchangenotific)
     */
    var textToSpeach: String = ""

    /**
     The skin-tone's variations of this emoji.

     For example, If the base emoji is 👮, the skinTones should be:

     ```swift
     let emoji = Emoji(character: .init("👮"))
     emoji.skinTones.forEach { print($0.character) }
     // Prints 👮🏻
     // Prints 👮🏼
     // Prints 👮🏽
     // Prints 👮🏾
     // Prints 👮🏿
     ```

     The emojis are ordered conforming unicode-org/cldr recommendations. You can get [👮🏿👮🏾👮🏽👮🏼👮🏻] reversed array by using `orderedSkinToneEmojis`.
     */
    var orderedSkinToneEmojis: [Emoji] = []

    /**
     Creates a new *Emoji* instance by the given character.
     */
    init(character: Character, group: String, subgroup: String) {
        self.character = character
        self.group = group
        self.subgroup = subgroup
    }

    
}

extension Emoji: Identifiable {

    /**
     The identifier of `Emoji`. Each emoji is identifed by its codepoints.
     */
    public var id: Character {
        return character
    }

}
