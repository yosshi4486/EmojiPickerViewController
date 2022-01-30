//
//  EmojiLoader.swift
//  
//
//  Created by yosshi4486 on 2022/01/27.
//

import Foundation

/**
 A type that loads all possible emoji that are defined in Unicode v14.0.

 - Note:
 `Loader` is designed rather than using `TopLevelDecoder` protocol, because `emoji-test` is NOT data format. It's only semi-colon separated plain text.

 */
public class EmojiLoader {

    /**
     The bundle where the resouces are located.
     */
    let bundle: Bundle

    /**
     Create an *Emoji Loader* instance by the given bundle.

     - Parameters:
       - bundle: The bundle for which loads resouces.
     */
    init(bundle: Bundle = Bundle.module) {

        self.bundle = bundle

    }

    /**
     Loads entire emojis.

     - Complexity:
     O(n) where n is number of emojis.

     - Parameters:
       - completionHandler:
         emojis: The all emojis which are ordered following a unicode definition. **It is not codepoint's order.**
     */
    func load() -> [Emoji] {

        var emojis: [Emoji] = []

        // The original resource is located at https://www.unicode.org/Public/emoji/14.0/emoji-test.txt .
        let emojiTestTextFileURL = bundle.url(forResource: "emoji-test", withExtension: "txt")!
        let emojiTestWholeText = try! String(contentsOf: emojiTestTextFileURL, encoding: .utf8)
        let emojiTestTextLines = emojiTestWholeText.split(separator: "\n")

        var group: Substring?
        var subgroup: Substring?

        /*
         The local var is used for handling skin tones. Adds skin-tone emojis into the `Emoji.skinTones` property, rather than adding it to `emojis` in this scope.
         */
        var skinToneBaseEmoji: Emoji?

        for (index, emojiOrderingTextLine) in emojiTestTextLines.enumerated() {

            /*
             There are three possible lines when the parser faces a "#":
             1. Comment
             2. Group name
             3. Subgroup name
             */
            if emojiOrderingTextLine.first == "#" {

                if emojiOrderingTextLine.hasPrefix("# group:"), let colonIndex = emojiOrderingTextLine.firstIndex(of: ":") {

                    let groupStartIndex = emojiOrderingTextLine.index(colonIndex, offsetBy: 2)
                    group = emojiOrderingTextLine.suffix(from: groupStartIndex)

                } else if emojiOrderingTextLine.hasPrefix("# subgroup:"),  let colonIndex = emojiOrderingTextLine.firstIndex(of: ":") {

                    let subgroupStartIndex = emojiOrderingTextLine.index(colonIndex, offsetBy: 2)
                    subgroup = emojiOrderingTextLine.suffix(from: subgroupStartIndex)

                }

                continue

            }

            let columns = emojiOrderingTextLine.split(separator: ";")
            guard columns.count == 2 else {
                fatalError("An iggegal form or a implementation problem is detected. Line in Whole Text: \(index), Line's Text: \(emojiOrderingTextLine)")
            }

            let hexCodepoints: [Substring] = columns[0].split(separator: " ")
            let status = columns[1].split(separator: "#").first!.trimmingCharacters(in: .whitespaces)

            guard status == "fully-qualified" else {
                continue
            }

            let unicodeScalars: [Unicode.Scalar] = hexCodepoints
                .compactMap({ UInt32($0, radix: 16) })  // Convert hex to UInt32.
                .compactMap({ Unicode.Scalar($0) })     // Convert UInt32 to Unicode.Scalar.

            assert(!unicodeScalars.isEmpty)

//            // Emoji Modifiers should not be showed.
//            if unicodeScalars.count == 1, unicodeScalars[0].properties.isEmojiModifier {
//                continue
//            }

            let unicodeScalarView = String.UnicodeScalarView(unicodeScalars)
            let character = Character(String(unicodeScalarView))

            let emoji = Emoji(character: character)
            emojis.append(emoji)
            skinToneBaseEmoji = emoji

//            if unicodeScalars[0].properties.isEmojiModifierBase {
//
//                emojis.append(emoji)
//                skinToneBaseEmoji = emoji
//
//            } else {
//
//                skinToneBaseEmoji?.orderedSkinToneEmojis.append(emoji)
//
//            }

        }

        return emojis
    }

}
