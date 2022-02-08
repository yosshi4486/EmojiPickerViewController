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

import XCTest
@testable import EmojiPickerViewController

class EmojiPickerItemTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testItemIdentityWhenSameCharacter() throws {

        let emoji = Emoji("😊")
        let recentlyUsed = EmojiPickerItem(emoji: emoji, itemType: .recentlyUsed)
        let searchResult = EmojiPickerItem(emoji: emoji, itemType: .searchResult)
        let labeled = EmojiPickerItem(emoji: emoji, itemType: .labeled)

        XCTAssertNotEqual(recentlyUsed, searchResult)
        XCTAssertNotEqual(recentlyUsed, labeled)
        XCTAssertNotEqual(searchResult, labeled)

        let recentlyUsed2 = EmojiPickerItem(emoji: emoji, itemType: .recentlyUsed)
        let searchResult2 = EmojiPickerItem(emoji: emoji, itemType: .searchResult)
        let labeled2 = EmojiPickerItem(emoji: emoji, itemType: .labeled)

        XCTAssertEqual(recentlyUsed, recentlyUsed2)
        XCTAssertEqual(searchResult, searchResult2)
        XCTAssertEqual(labeled, labeled2)

    }

    func testItemIdentityWhenDifferenceCharacter() throws {

        let recentlyUsed = EmojiPickerItem(emoji: Emoji("😍"), itemType: .recentlyUsed)
        let searchResult = EmojiPickerItem(emoji: Emoji("🍎"), itemType: .searchResult)
        let labeled = EmojiPickerItem(emoji: Emoji("🚜"), itemType: .labeled)

        XCTAssertNotEqual(recentlyUsed, searchResult)
        XCTAssertNotEqual(recentlyUsed, labeled)
        XCTAssertNotEqual(searchResult, labeled)

        let recentlyUsed2 = EmojiPickerItem(emoji: Emoji("❤️"), itemType: .recentlyUsed)
        let searchResult2 = EmojiPickerItem(emoji: Emoji("💾"), itemType: .searchResult)
        let labeled2 = EmojiPickerItem(emoji: Emoji("📊"), itemType: .labeled)

        XCTAssertNotEqual(recentlyUsed, recentlyUsed2)
        XCTAssertNotEqual(searchResult, searchResult2)
        XCTAssertNotEqual(labeled, labeled2)

    }


}
