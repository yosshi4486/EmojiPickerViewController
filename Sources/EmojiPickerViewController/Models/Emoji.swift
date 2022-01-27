//
//  Emoji.swift
//  
//
//  Created by yosshi4486 on 2022/01/27.
//

import Foundation

/**
A type that represents `Emoji`.
 */
final class Emoji {

    /**
     The character that represents this emoji.

     The value may have several codepoints, such as skin toned emoji. You can access them via `utf8` property.
     */
    let character: Character

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
     */
    var skinTones: [Emoji] = []

    /**
     Creates a new *Emoji* instance by the given character.
     */
    init(character: Character) {
        self.character = character
    }

    
}

extension Emoji: Identifiable {

    /**
     The identifier of `Emoji`. Each emoji is identifed by its codepoints.
     */
    var id: Character {
        return character
    }

}
