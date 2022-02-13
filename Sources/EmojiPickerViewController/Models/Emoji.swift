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
     A status of an emoji.

     The specifications of this *Status* are defined in [UTS #51](https://unicode.org/reports/tr51/)
     */
    public enum Status: String {

        /**
         The component status.

         > ED-5. emoji component — A character that has the Emoji_Component property.
         > These characters are used in emoji sequences but normally do not appear on emoji keyboards as separate choices, such as keycap base characters or Regional_Indicator characters.
         > Some emoji components are emoji characters, and others (such as tag characters and ZWJ) are not.
         > (© 2021 Unicode, Inc, UNICODE EMOJI, 1.4.1 Emoji Characters, ED-5. emoji component, https://unicode.org/reports/tr51/#def_level2_emoji, viewed: 2022/01/30)
         */
        case component

        /**
         The fully qualified status.

         > ED-18. fully-qualified emoji — A qualified emoji character, or an emoji sequence in which each emoji character is qualified.
         > (© 2021 Unicode, Inc, UNICODE EMOJI, 1.4.5 Emoji Sequences, ED-18. fully-qualified emoji , https://unicode.org/reports/tr51/#def_fully_qualified_emoji, viewed: 2022/01/30)
         */
        case fullyQualified = "fully-qualified"

        /**
         The minimally qualified status.

         > ED-18a. minimally-qualified emoji — An emoji sequence in which the first character is qualified but the sequence is not fully qualified.
         > (© 2021 Unicode, Inc, UNICODE EMOJI, 1.4.5 Emoji Sequences, ED-18a. minimally-qualified emoji , https://unicode.org/reports/tr51/#def_minimally_qualified_emoji, viewed: 2022/01/30)
         */
        case minimallyQualified = "minimally-qualified"

        /**
         The unqualified status.

         > ED-19. unqualified emoji — An emoji that is neither fully-qualified nor minimally qualified.
         > (© 2021 Unicode, Inc, UNICODE EMOJI, 1.4.5 Emoji Sequences, ED-19. unqualified emoji , https://unicode.org/reports/tr51/#def_unqualified_emoji, viewed: 2022/01/30)
         */
        case unqualified

    }


    /**
     The character representation of the emoji.
     */
    public let character: Character

    /**
     The status of the emoji.
     */
    public let status: Emoji.Status

    /**
     The emoji order which unicode-org/cldr provides.  The emojis in `Resources/emoji-test.txt` are following CLDR order.
     */
    public let cldrOrder: Int

    /**
     The group name where the emoji belongs. This property is set following `Resources/emoji-test.txt`. Ex.) Smileys & Emotion, People & Body
     */
    public let group: String

    /**
     The subgroup name where the emoji belongs. This property is set following `Resources/emoji-test.txt`. Ex.) face-smiling, hand-fingers-open
     */
    public let subgroup: String

    /**
     The annotation for searching emojis. The value includes multiple annotation which are separated by vertical line "|",  such as `face | geek | nerd`. This property is set following`Resources/CLDR/annotation` and `Resources/CLDR/annotationsDerived` .

     This property can be replaced when the keyboard's primary language is changed. The default value is empty, however an actual value will be set later.

     - SeeAlso: [UITextInputMode.currentInputModeDidChangeNotification](https://developer.apple.com/documentation/uikit/uitextinputmode/1614517-currentinputmodedidchangenotific)
     */
    internal(set) public var annotation: String = ""

    /**
     The tts value for screen reader functionality. In Apple Platform, the value should be read by VoiceOver. This property is set following`Resources/CLDR/annotations` and `Resources/CLDR/annotationsDerived`

     This property can be replaced when the keyboard's primary language is changed. The default value is empty, however an actual value will be set later.

     - SeeAlso: [UITextInputMode.currentInputModeDidChangeNotification](https://developer.apple.com/documentation/uikit/uitextinputmode/1614517-currentinputmodedidchangenotific)
     */
    internal(set) public var textToSpeach: String = ""

    /**
     The skin-tone's variations of this emoji. The value is `empty` when the emoji is not emoji modifier base.

     For instance, when this emoji is 👮, the `orderedSkinToneEmojis` are:

     ```swift
     let emoji = Emoji(character: .init("👮"))
     emoji.orderedSkinToneEmojis.forEach { print($0.character) }
     // Prints 👮🏻
     // Prints 👮🏼
     // Prints 👮🏽
     // Prints 👮🏾
     // Prints 👮🏿
     ```

     The status of each emoji element is `.fullyQualified`. If the element has its minimaly-qualified or unqualified variations, they are set into `element.minimallyQualifiedOrUnqualifiedVersions`.
     */
    internal(set) public var orderedSkinToneEmojis: [Emoji] = []

    /**
     The generic skin-toneed emoji. The value is `nil` when this emoji is not emoji modifier sequence.

     For instance,   when this emoji is 👮🏽, the `genericSkinToneEmoji` is 👮.

     - Note:
     The term of "generic" is described in [UTS #51, 2.4 Diversity](https://unicode.org/reports/tr51/#Diversity)
     */
    internal(set) public weak var genericSkinToneEmoji: Emoji?

    /**
     The other qualified version of this emoji. The value is `empty` when there is no qualified variations.

     For instance, when this emoji is 👮‍♂️(1F46E 200D 2642 FE0F), the `minimallyQualifiedOrUnqualifiedVersions` is  [👮‍♂(1F46E 200D 2642)] which the element doesn't have an emoji presentation selector (U+FE0F).

     Some emojis can have several unqualified versions of emoji like bellows:

     ```
     🕵️‍♂️(1F575 FE0F 200D 2642 FE0F): fully-qualified
     🕵‍♂️(1F575 200D 2642 FE0F)     : unqualified
     🕵️‍♂(1F575 FE0F 200D 2642)   : unqualified
     🕵‍♂(1F575 200D 2642)          : unqualified
     ```
     */
    internal(set) public var minimallyQualifiedOrUnqualifiedVersions: [Emoji] = []

    /**
     The fully qualified version of this emoji. The value is `nil` when the status of this emoji is fully qualififed.

     For instance, when this emoji is 👮‍♂️(1F46E 200D 2642), the `fullyQualifiedVersion` is 👮‍♂️(1F46E 200D 2642 FE0F).
     */
    internal(set) public weak var fullyQualifiedVersion: Emoji?

    /**
     Creates a new *Emoji* instance by the required parameters.

     - Parameters:
       - character: The character that represents an emoji.
       - status: The status of the emoji.
       - cldrOrder: The CLDR integer order for keyboard.
       - group: The group name where the emoji belongs.
       - subgroup: The subgroup name where the emoji belongs.
     */
    init(character: Character, status: Status, cldrOrder: Int, group: String, subgroup: String) {
        self.character = character
        self.status = status
        self.cldrOrder = cldrOrder
        self.group = group
        self.subgroup = subgroup
    }

}

extension Emoji {

    /**
     Creates a new *Emoji* instance by the required parameters.

     - Parameters:
       - s: The string that represents a single extended grapheme cluster.
       - status: The status of the emoji.
       - cldrOrder: The CLDR integer order for keyboard.
       - group: The group name where the emoji belongs.
       - subgroup: The subgroup name where the emoji belongs.
     */
    convenience init(_ s: String, status: Status = .fullyQualified, cldrOrder: Int = 0, group: String = "", subgroup: String = "") {
        self.init(character: Character(s), status: status, cldrOrder: cldrOrder, group: group, subgroup: subgroup)
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

extension Emoji: Equatable {

    public static func == (lhs: Emoji, rhs: Emoji) -> Bool {
        return lhs.character == rhs.character
    }

}

extension Emoji: Hashable {

    public func hash(into hasher: inout Hasher) {
        hasher.combine(character)
    }

}

extension Emoji: CustomStringConvertible {

    public var description: String {

        """
        <Emoji:\(Unmanaged.passUnretained(self).toOpaque()) character=\(character) status=\(status) cldrOrder=\(cldrOrder) group=\(group) subgroup=\(subgroup) annotation=\(annotation) textToSpeach=\(textToSpeach) orderedSkinToneEmojis=\(orderedSkinToneEmojis) genericSkinToneEmoji=\(String(describing: genericSkinToneEmoji)) minimallyQualifiedOrUnqualifiedVersions=\(minimallyQualifiedOrUnqualifiedVersions) fullyQualifiedVersion=\(String(describing: fullyQualifiedVersion))>
        """

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
