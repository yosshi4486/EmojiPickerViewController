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
final class Emoji: Identifiable {

    /**
     The character that represents this emoji.

     The value may have several codepoints, such as skin toned emoji. You can access them via `utf8` property.
     */
    let character: Character

    /**
     The identifier of `Emoji`. Each emoji is identifed by its codepoints.
     */
    var id: Character {
        return self.character
    }

    /**
     Creates a new *Emoji* instance by the given character.
     */
    init(character: Character) {
        self.character = character
    }

    
}
