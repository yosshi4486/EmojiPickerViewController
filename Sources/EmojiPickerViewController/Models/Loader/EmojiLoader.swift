//
//  EmojiLoader.swift
//  
//
//  Created by yosshi4486 on 2022/01/27.
//

import Foundation

/**
 A type that loads all possible emoji that are defined in Unicode v14.0.

 The resource which this object loads is located at  https://www.unicode.org/Public/emoji/14.0/emoji-test.txt , this loader loads data following the format.

 - Note:
 `Loader` is designed rather than using `TopLevelDecoder` protocol, because `emoji-test` is NOT data format. It's only semi-colon separated plain text.

 */
public class EmojiLoader {

    /**
     A row of `emoji-test.txt`.
     */
    public enum Row<S: StringProtocol>: Equatable {

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
        internal init(_ lineString: S) {

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
    public struct Data: Equatable {

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
         The unicode scalars of the emoji.
         */
        public let unicodeScalars: [Unicode.Scalar]

        /**
         The status of the emoji.
         */
        public let status: Status

        /**
         Creates a *Data* instance by the given data's row string. This initializer returns `nil` if the given `dataRowString` doesn't follow the correct format.

         - Parameters:
           - dataRowString: The row string that includues a codepoints and status.
         */
        internal init?<S: StringProtocol>(dataRowString: S) {

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

            guard let status = Status(rawValue: statusRawString.trimmingCharacters(in: .whitespaces)) else {
                return nil
            }

            self.unicodeScalars = unicodeScalars
            self.status = status

        }

    }

    /**
     The `main` loader instance to load emojis. You can only access to `main`.
     */
    public static let main = EmojiLoader()

    /**
     The bundle where the resouces are located. In swift package system, `.module` specifies the resource's bundle of the current module.
     */
    let bundle: Bundle = .module

    /**
     Loads entire emojis.

     - Complexity:
     O(n) where n is number of emojis.

     - Returns:
     A dictionay which the key is `Character` and the value is `Emoji`. `Dictionary` is more useful for searching and replacing thire properties, rather than using `Array`.
     */
    public func load() -> [Emoji.ID: Emoji] {

        var dictionary: [Emoji.ID: Emoji] = [:]

        let emojiTestTextFileURL = bundle.url(forResource: "emoji-test", withExtension: "txt")!
        let emojiTestWholeText = try! String(contentsOf: emojiTestTextFileURL, encoding: .utf8)
        let emojiTestTextLines = emojiTestWholeText.split(separator: "\n")

        var group: Substring?
        var subgroup: Substring?

        /*
         The local var is used for handling skin tones. Adds skin-tone emojis into the `Emoji.skinTones` property, rather than adding it to `emojis` in this scope.
         */
        var skinToneBaseEmoji: Emoji?

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

            guard case .fullyQualified = data.status else {
                continue
            }

            let unicodeScalars = data.unicodeScalars
            let unicodeScalarView = String.UnicodeScalarView(unicodeScalars)
            let character = Character(String(unicodeScalarView))

            let emoji = Emoji(character: character, recommendedOrder: UInt(exactly: emojiOrder)!, group: String(group!), subgroup: String(subgroup!))

            if emoji.isEmojiModifierSequence {
                skinToneBaseEmoji?.orderedSkinToneEmojis.append(emoji)
            } else {
                dictionary[emoji.id] = emoji
                skinToneBaseEmoji = emoji
            }

            // The value is decremented only when the row is for an emoji data.
            emojiOrder += 1

        }

        return dictionary
    }

}
