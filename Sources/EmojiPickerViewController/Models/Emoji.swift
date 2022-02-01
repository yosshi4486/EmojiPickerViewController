//
//  Emoji.swift
//
//  EmojiPickerViewController
//  https://github.com/yosshi4486/EmojiPickerViewController
//
//  Created by yosshi4486 on 2022/01/31.
//
// ----------------------------------------------------------------------------
//
//  © 2022  yosshi4486
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
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
public class Emoji {

    /**
     The character representation of the emoji.
     */
    public let character: Character

    /**
     The group name where the emoji belongs. This property is set following `Resources/emoji-test.txt`. Ex.) Smileys & Emotion, People & Body
     */
    public let group: String

    /**
     The subgroup name where the emoji belongs. This property is set following `Resources/emoji-test.txt`. Ex.) face-smiling, hand-fingers-open
     */
    public let subgroup: String

    /**
     The recommended emoji order which CLDR provides.  The emojis in `Resources/emoji-test.txt` are following CLDR order.
     */
    public let recommendedOrder: UInt

    /**
     The label of the emoji, which is used as category as usual.

     - Note:
     unicode-org/cldr has a `labels.text` file for labeling emojis, but parsing it and setting lables to emojis takes time and effort, so we decided to compute the label from `group` and `subgroup` for ease.

     - SeeAlso: [unicode-org/cldr/common/properties/label.txt](https://github.com/unicode-org/cldr/blob/main/common/properties/labels.txt)
     */
    public var localizedLabel: String? {

        switch group {

        case "Smileys & Emotion", "People & Body":
            return NSLocalizedString("smileys_people", bundle: .module, comment: "Emoji label: groups emojis into Smileys & People.")

        case "Animals & Nature":
            return NSLocalizedString("animals_nature", bundle: .module, comment: "Emoji label: groups emojis into Animals & Nature.")

        case "Food & Drink":
            return NSLocalizedString("food_drink", bundle: .module, comment: "Emoji label: groups emojis into Food & Drink.")

        case "Travel & Places":
            return NSLocalizedString("travel_places", bundle: .module, comment: "Emoji label: groups emojis into Travel & Places.")

        case "Activities":
            return NSLocalizedString("activities", bundle: .module, comment: "Emoji label: groups emojis into Activities.")

        case "Objects":
            return NSLocalizedString("objects", bundle: .module, comment: "Emoji label: groups emojis into Objects.")

        case "Symbols":
            return NSLocalizedString("symbols", bundle: .module, comment: "Emoji label: groups emojis into Symbols.")

        case "Flags":
            return NSLocalizedString("flags", bundle: .module, comment: "Emoji label: groups emojis into Flags.")

        default: // "Component" or future added unknown groups returns nil.
            return nil

        }

    }

    /**
     The annotations for searching emojis. The value includes multiple annotations which are separated by vertical line "|",  such as `face | geek | nerd`. This property is set following`Resources/CLDR/annotations` and `Resources/CLDR/annotationsDerived` .

     This property can be replaced when the keyboard's primary language is changed. The default value is empty, however an actual value will be set later.

     - SeeAlso: [UITextInputMode.currentInputModeDidChangeNotification](https://developer.apple.com/documentation/uikit/uitextinputmode/1614517-currentinputmodedidchangenotific)
     */
    internal(set) public var annotations: String = ""

    /**
     The tts value for screen reader functionality. In Apple Platform, the value should be read by VoiceOver. This property is set following`Resources/CLDR/annotations` and `Resources/CLDR/annotationsDerived`

     This property can be replaced when the keyboard's primary language is changed. The default value is empty, however an actual value will be set later.

     - SeeAlso: [UITextInputMode.currentInputModeDidChangeNotification](https://developer.apple.com/documentation/uikit/uitextinputmode/1614517-currentinputmodedidchangenotific)
     */
    internal(set) public var textToSpeach: String = ""

    /**
     The skin-tone's variations of this emoji.

     For example, If the base emoji is 👮, the `orderedSkinToneEmojis` are:

     ```swift
     let emoji = Emoji(character: .init("👮"))
     emoji.orderedSkinToneEmojis.forEach { print($0.character) }
     // Prints 👮🏻
     // Prints 👮🏼
     // Prints 👮🏽
     // Prints 👮🏾
     // Prints 👮🏿
     ```

     The emojis are ordered conforming unicode-org/cldr recommendations. You can get [👮🏿👮🏾👮🏽👮🏼👮🏻] reversed array by using `orderedSkinToneEmojis.reversed()`.
     */
    internal(set) public var orderedSkinToneEmojis: [Emoji] = []

    /**
     Creates a new *Emoji* instance by the required parameters.

     - Parameters:
       - character: The character that represents an emoji.
       - recommendedOrder: The CLDR unsigned integer order for keyboard.
       - group: The group name where the emoji belongs.
       - subgroup: The subgroup name where the emoji belongs.
     */
    init(character: Character, recommendedOrder: UInt, group: String, subgroup: String) {
        self.character = character
        self.recommendedOrder = recommendedOrder
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

extension Emoji {

    /**
     Returns boolean value indicating whether this emoji consists of *Emoji Modifier Sequence*.

     > ED-13. emoji modifier sequence — A sequence of the following form:
     > emoji_modifier_sequence := emoji_modifier_base emoji_modifier
     > (© 2021 Unicode, Inc, UNICODE EMOJI, 1.4.4 Emoji Modifiers, ED-13. emoji modifier sequence, https://unicode.org/reports/tr51/#def_emoji_modifier_sequence, viewed: 2022/01/30)

     - Complexity: O(n) where n is number of unicode scalars in the character.
     */
    public var isEmojiModifierSequence: Bool {

        let scalars = character.unicodeScalars

        // In this repository, emoji modifiers can not exist in isolate.
        if scalars.count == 1 {
            assert(!character.unicodeScalars.first!.properties.isEmojiModifier)
            return false
        }

        // emoji_modifier_sequence := emoji_modifier_base emoji_modifier
        var index: Int = 1
        while index < scalars.count {

            let accessor = scalars.index(scalars.startIndex, offsetBy: index)

            if scalars[accessor].properties.isEmojiModifier {
                return true
            }

            // The next codepoints of zwj must be emoji_modifier_base.
            if scalars[accessor].properties.isJoinControl {

                index += 2

            } else {

                index += 1
                
            }

        }

        return false

    }

}
