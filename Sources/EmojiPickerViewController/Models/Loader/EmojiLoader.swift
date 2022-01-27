//
//  EmojiLoader.swift
//  
//
//  Created by yosshi4486 on 2022/01/27.
//

import Foundation

/**
 A type that loads all possible emoji that are defined in Unicode v14.0.
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

        let emojiOrderingFileURL = bundle.url(forResource: "emoji-ordering", withExtension: "txt")!
        let emojiOrderingWholeText = try! String(contentsOf: emojiOrderingFileURL, encoding: .utf8)
        let emojiOrderingTextLines = emojiOrderingWholeText.split(separator: "\n")

        for emojiOrderingTextLine in emojiOrderingTextLines {

            guard emojiOrderingTextLine.first != "#" else {
                continue
            }

            // guard initial comments.
            guard let unicodeHexes: [Substring] = emojiOrderingTextLine.split(separator: ";").first?.split(separator: " ") else {
                continue
            }

            let unicodeScalars: [Unicode.Scalar] = unicodeHexes
                .map({ ($0.dropFirst(2)) })             // Remove U+.
                .compactMap({ UInt32($0, radix: 16) })  // Convert hex to UInt32.
                .compactMap({ Unicode.Scalar($0) })     // Convert UInt32 to Unicode.Scalar.

            let unicodeScalarView = String.UnicodeScalarView(unicodeScalars)
            let character = Character(String(unicodeScalarView))
            let emoji = Emoji(character: character)
            emojis.append(emoji)
        }

        return emojis
    }

}
