//
//  EmojiLoader.swift
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
 A type that loads all possible emoji that are defined in Unicode v14.0.

 The resource which this object loads is located at  https://www.unicode.org/Public/emoji/14.0/emoji-test.txt , this loader loads data following the format.

 - Note:
 `Loader` is designed rather than using `TopLevelDecoder` protocol, because `emoji-test` is NOT data format. It's only semi-colon separated plain text.

 - TODO:
 This class is not thread safe, it doesn't do anything about data race. Implements as `actor`?
 */
class EmojiLoader: Loader {

    /**
     A row of `emoji-test.txt`.
     */
    enum Row<S: StringProtocol>: Equatable {

        /**
         The comment row. It should be ignored in parsing.

         For instance:
         ```
         # Emoji Keyboard/Display Test Data for UTS #51
         ```
         */
        case comment

        /**
         The header row that indicates group name. The associated value is a group name, which is trimmed row comments and whitespaces.

         For instance:
         ```
         # group: Smileys & Emotion
         ```
         */
        case groupHeader(groupName: S.SubSequence)

        /**
         The header row that indicates subgroup name. The associated value is a subgroup name, which is trimmed row comments and whitespaces.

         For instance:
         ```
         # subgroup: face-smiling
         ```
         */
        case subgroupHeader(suggroupName: S.SubSequence)

        /**
         The data row that indicates emoji data.

         For instance:
         ```
         1F636 200D 1F32B FE0F; fully-qualified # 😶‍🌫️ E13.1 face in clouds
         ```
         */
        case data(EmojiLoader.Data)

        /**
         Creates a *Row* instance by the given line's string, which the original string is the whole text of `emoji-test.txt`.

         This initializer initializes `self` to `.comment` if the format of the given `lineString` is unknown. (Not in emoji-test.txt)

         - Parameters:
           - lineString:The string object that represents a line of the whole `emoji-test.txt` text.
         */
        init(_ lineString: S) {

            if lineString.first == "#" {

                if lineString.hasPrefix("# group:"), let colonIndex = lineString.firstIndex(of: ":"), let groupStartIndex = lineString.index(colonIndex, offsetBy: 2, limitedBy: lineString.endIndex) {

                    let groupName = lineString.suffix(from: groupStartIndex)
                    self = .groupHeader(groupName: groupName)

                } else if lineString.hasPrefix("# subgroup:"),  let colonIndex = lineString.firstIndex(of: ":"), let subgroupStartIndex = lineString.index(colonIndex, offsetBy: 2, limitedBy: lineString.endIndex) {

                    let subgroupName = lineString.suffix(from: subgroupStartIndex)
                    self = .subgroupHeader(suggroupName: subgroupName)

                } else {

                    self = .comment

                }

            } else {

                guard let data = EmojiLoader.Data(dataRowString: lineString) else {
                    self = .comment
                    return
                }

                self = .data(data)

            }

        }

    }

    /**
     A  emoji data structure of `emoji-test.txt`.
     */
    struct Data: Equatable {

        /**
         The unicode scalars of the emoji.
         */
        let unicodeScalars: [Unicode.Scalar]

        /**
         The status of the emoji.
         */
        let status: Emoji.Status

        /**
         Creates a *Data* instance by the given data's row string. This initializer returns `nil` if the given `dataRowString` doesn't follow the correct format.

         - Parameters:
           - dataRowString: The row string that includues a codepoints and status.
         */
        init?<S: StringProtocol>(dataRowString: S) {

            /*
             The goal of this initialization is parsing the below to get the unicode scalars and status.
             `1F636 200D 1F32B FE0F                                  ; fully-qualified     # 😶‍🌫️ E13.1 face in clouds`
             */

            let columns = dataRowString.split(separator: ";")
            guard columns.count == 2 else {
                return nil
            }

            let codePointsColumn = columns[0]
            let statusColumn = columns[1] // includes line comments and whitespaces.

            let unicodeScalars: [Unicode.Scalar] = codePointsColumn.split(separator: " ").compactMap({ UInt32($0, radix: 16) }).compactMap({ Unicode.Scalar($0) })
            guard !unicodeScalars.isEmpty else {
                return nil
            }

            let statusRawString: S.SubSequence
            if let commentIndex = statusColumn.firstIndex(of: "#") {

                statusRawString = statusColumn.prefix(upTo: commentIndex)

            } else {

                statusRawString = statusColumn

            }

            guard let status = Emoji.Status(rawValue: statusRawString.trimmingCharacters(in: .whitespaces)) else {
                return nil
            }

            self.unicodeScalars = unicodeScalars
            self.status = status

        }

    }

    private(set) var wholeEmojiDictionary: [Emoji.ID: Emoji] = [:]

    private(set) var fullyQualifiedOrderedEmojisForKeyboard: [Emoji] = []

    /**
     Loads entire emojis and returns them.

     - Complexity:
     O(n) where n is number of lines in `emoji-test.txt`.
     */
    func load() {

        // Cleanup loaded data
        if !(wholeEmojiDictionary.isEmpty && fullyQualifiedOrderedEmojisForKeyboard.isEmpty) {
            wholeEmojiDictionary = [:]
            fullyQualifiedOrderedEmojisForKeyboard = []
        }

        let emojiTestFileURL = bundle.url(forResource: "emoji-test", withExtension: "txt")
        let emojiTestWholeText = try! String(contentsOf: emojiTestFileURL!, encoding: .utf8)
        let emojiTestTextLines = emojiTestWholeText.split(separator: "\n")

        var group: Substring?
        var subgroup: Substring?

        /*
         The local var are used for handling skin tones and minimally-qualified/unqualified versions.

         The most important expectation for combining variations is the orders of emojis in the `emoji-test.txt` file. The rules of the order are:
         1. fully-qualified and non emoji modiifier sequence, which we name "variation base" is located at head. This is a separater of the variations of the emoji.
         2. minimally-qualified or unqualified emojis are listed next of 1.
         3. modifier sequences(skintoned emoji) are listed next of 2.
         NOTE: modifier sequences may have its monimally-qualified or unqualified variations.

         Ex)
         1F575 FE0F 200D 2642 FE0F                              ; fully-qualified     # 🕵️‍♂️ E4.0 man detective                             <VARIATION BASE>
         1F575 200D 2642 FE0F                                   ; unqualified         # 🕵‍♂️ E4.0 man detective                             <VARIATION OF VARIATION BASE>
         1F575 FE0F 200D 2642                                   ; unqualified         # 🕵️‍♂ E4.0 man detective                           <VARIATION OF VARIATION BASE>
         1F575 200D 2642                                        ; unqualified         # 🕵‍♂ E4.0 man detective                             <VARIATION OF VARIATION BASE>
         1F575 1F3FB 200D 2642 FE0F                             ; fully-qualified     # 🕵🏻‍♂️ E4.0 man detective: light skin tone            <MODIFIER SEQUENCE OF VARIATION BASE>
         1F575 1F3FB 200D 2642                                  ; minimally-qualified # 🕵🏻‍♂ E4.0 man detective: light skin tone            <VARIATION OF MODIFIER SEQUENCE>
         1F575 1F3FC 200D 2642 FE0F                             ; fully-qualified     # 🕵🏼‍♂️ E4.0 man detective: medium-light skin tone     <MODIFIER SEQUENCE OF VARIATION BASE>
         1F575 1F3FC 200D 2642                                  ; minimally-qualified # 🕵🏼‍♂ E4.0 man detective: medium-light skin tone     <VARIATION OF MODIFIER SEQUENCE>
         1F575 1F3FD 200D 2642 FE0F                             ; fully-qualified     # 🕵🏽‍♂️ E4.0 man detective: medium skin tone           <MODIFIER SEQUENCE OF VARIATION BASE>
         1F575 1F3FD 200D 2642                                  ; minimally-qualified # 🕵🏽‍♂ E4.0 man detective: medium skin tone           <VARIATION OF MODIFIER SEQUENCE>
         1F575 1F3FE 200D 2642 FE0F                             ; fully-qualified     # 🕵🏾‍♂️ E4.0 man detective: medium-dark skin tone      <MODIFIER SEQUENCE OF VARIATION BASE>
         1F575 1F3FE 200D 2642                                  ; minimally-qualified # 🕵🏾‍♂ E4.0 man detective: medium-dark skin tone      <VARIATION OF MODIFIER SEQUENCE>
         1F575 1F3FF 200D 2642 FE0F                             ; fully-qualified     # 🕵🏿‍♂️ E4.0 man detective: dark skin tone             <MODIFIER SEQUENCE OF VARIATION BASE>
         1F575 1F3FF 200D 2642                                  ; minimally-qualified # 🕵🏿‍♂ E4.0 man detective: dark skin tone             <VARIATION OF MODIFIER SEQUENCE>

         1F575 FE0F 200D 2640 FE0F                              ; fully-qualified     # 🕵️‍♀️ E4.0 woman detective                           <NEXT VARIATION BASE>
         */

        // Variation base is fully-qualified and non emoji modiifier sequence.
        var variationBaseEmoji:Emoji?

        // FullyQualifiedEmoji is fully-qualified. It may be mofifier sequence.
        var fullyQualifiedEmoji: Emoji?

        var emojiOrder: Int = 0

        for emojiTestTextLine in emojiTestTextLines {

            let row = Row(emojiTestTextLine)

            guard case .data(let data) = row else {

                if case .groupHeader(let name) = row {

                    group = name

                } else if case .subgroupHeader(suggroupName: let name) = row {

                    subgroup = name

                }

                continue
            }

            let unicodeScalars = data.unicodeScalars
            let unicodeScalarView = String.UnicodeScalarView(unicodeScalars)
            let character = Character(String(unicodeScalarView))

            let emoji = Emoji(character: character, status: data.status, cldrOrder: emojiOrder, group: String(group!), subgroup: String(subgroup!))

            wholeEmojiDictionary[character] = emoji

            switch data.status {
            case .fullyQualified:

                fullyQualifiedEmoji = emoji

                if emoji.isEmojiModifierSequence {

                    variationBaseEmoji?.orderedSkinToneEmojis.append(emoji)
                    emoji.genericSkinToneEmoji = variationBaseEmoji

                } else {

                    // Normally, a keyboard should present only variation base emojis, and present modifier sequences(skintoned) by long-pressing the key.

                    variationBaseEmoji = emoji
                    fullyQualifiedOrderedEmojisForKeyboard.append(emoji)

                }

            case .minimallyQualified, .unqualified:

                fullyQualifiedEmoji?.minimallyQualifiedOrUnqualifiedVersions.append(emoji)
                emoji.fullyQualifiedVersion = fullyQualifiedEmoji

            case .component:
                break // Do nothing
            }

            // The value is decremented only when the row is for an emoji data.
            emojiOrder += 1

        }

    }

}
