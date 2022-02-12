//
//  EmojiPickerItem.swift
//
//  EmojiPickerViewController
//  https://github.com/yosshi4486/EmojiPickerViewController
//
//  Created by yosshi4486 on 2022/02/08.
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
#if os(iOS)

import Foundation

/**
 An item of emoji picker.

 Since `UICollectionViewDiffableDataSource` detects the data identity using the id property, a raw `Emoji` object that wants to appear in several sections is recognized as the same item. The purpose of this type is to give the ability for an emoji to appear in several sections.
 */
enum EmojiPickerItem {
    

    /**
     The item type for  a `.recentlyUsed` section.
     */
    case recentlyUsed(Emoji)

    /**
     The item type for  a `.searchResult` section.
     */
    case searchResult(Emoji)

    /**
     The item type for  a `.smileysPeople`, `.animalsNature`, `.foodDrink`, `.travelPlaces`,  `.activities`, `.objects`, `.symbols` or `.flags` section.
     */
    case labeled(Emoji)

    /**
     The item type for empty section.
     */
    case empty

    /**
     The emoji that is associated with this item. Returns non-nil value if the case is `.recentlyUsed`, `.searchResult` or `.labeled`. Otherwise; returns `nil`.
     */
    var emoji: Emoji? {

        switch self {

        case .recentlyUsed(let emoji):
            return emoji

        case .searchResult(let emoji):
            return emoji

        case .labeled(let emoji):
            return emoji

        case .empty:
            return nil
            
        }

    }

}

extension EmojiPickerItem: Hashable { }

extension EmojiPickerItem: Identifiable {

    /*
     Identifies the item by its itemType and emoji's character.

     This allows:
     - An emoji appears in several sections

     This doesn't allows:
     - An emoji appears several times in a section.
     */
    var id: String {

        switch self {
        case .recentlyUsed(let emoji):
            return "0_\(emoji.id)"

        case .searchResult(let emoji):
            return "1_\(emoji.id)"

        case .labeled(let emoji):
            return "2_\(emoji.id)"

        case .empty:
            return "3"
        }

    }

}
#endif
