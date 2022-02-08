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

import Foundation

/**
 An item of emoji picker.

 Since `UICollectionViewDiffableDataSource` detects the data identity using the id property, a raw `Emoji` object that wants to appear in several sections is recognized as the same item. The purpose of this type is to give the ability for an emoji to appear in several sections.
 */
struct EmojiPickerItem {

    /**
     A type for emoji picker item.
     */
    enum ItemType: Int {

        /**
         The item type for  a `.recentlyUsed` section.
         */
        case recentlyUsed

        /**
         The item type for  a `.searchResult` section.
         */
        case searchResult

        /**
         The item type for  a `.smileysPeople`, `.animalsNature`, `.foodDrink`, `.travelPlaces`,  `.activities`, `.objects`, `.symbols` or `.flags` section.
         */
        case labeled
    }

    /**
     The emoji which is shown in a cell.
     */
    let emoji: Emoji

    /**
     The item type of this picker item.
     */
    let itemType: ItemType

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
        return "\(itemType.rawValue)_\(emoji.id)"
    }

}
