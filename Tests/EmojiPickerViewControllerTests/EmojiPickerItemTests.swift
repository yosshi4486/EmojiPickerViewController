//
//  EmojiPickerItemTests.swift
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

import Testing
@testable import EmojiPickerViewController

@Suite
struct EmojiPickerItemTests {
    
    @Test @MainActor
    func itemIdentityWhenSameCharater() {
        let emoji = Emoji("😊")
        let recentlyUsed = EmojiPickerItem.recentlyUsed(emoji)
        let searchResult = EmojiPickerItem.searchResult(emoji)
        let labeled = EmojiPickerItem.labeled(emoji)
        let empty = EmojiPickerItem.empty
        
        #expect(recentlyUsed != searchResult)
        #expect(recentlyUsed != labeled)
        #expect(recentlyUsed != empty)
        #expect(searchResult != labeled)
        #expect(searchResult != empty)
        #expect(labeled != empty)
        
        let recentlyUsed2 = EmojiPickerItem.recentlyUsed(emoji)
        let searchResult2 = EmojiPickerItem.searchResult(emoji)
        let labeled2 = EmojiPickerItem.labeled(emoji)
        let empty2 = EmojiPickerItem.empty
        
        #expect(recentlyUsed == recentlyUsed2)
        #expect(searchResult == searchResult2)
        #expect(labeled == labeled2)
        #expect(empty == empty2)
    }
    
    @Test @MainActor
    func itemIdentityWhenDifferenceCharater() {
        let recentlyUsed = EmojiPickerItem.recentlyUsed(Emoji("😍"))
        let searchResult = EmojiPickerItem.searchResult(Emoji("🍎"))
        let labeled = EmojiPickerItem.labeled(Emoji("🚜"))
        let empty = EmojiPickerItem.empty // It doesn't have an emoji.
        
        #expect(recentlyUsed != searchResult)
        #expect(recentlyUsed != labeled)
        #expect(recentlyUsed != empty)
        #expect(searchResult != labeled)
        #expect(searchResult != empty)
        #expect(labeled != empty)
        
        let recentlyUsed2 = EmojiPickerItem.recentlyUsed(Emoji("❤️"))
        let searchResult2 = EmojiPickerItem.searchResult(Emoji("💾"))
        let labeled2 = EmojiPickerItem.labeled(Emoji("📊"))
        let empty2 = EmojiPickerItem.empty // It doesn't have an emoji.
        
        #expect(recentlyUsed != recentlyUsed2)
        #expect(searchResult != searchResult2)
        #expect(labeled != labeled2)
        #expect(empty == empty2)
    }
    
}
