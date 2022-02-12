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

#if os(iOS)
class EmojiPickerItemTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testItemIdentityWhenSameCharacter() throws {

        let emoji = Emoji("😊")
        let recentlyUsed = EmojiPickerItem.recentlyUsed(emoji)
        let searchResult = EmojiPickerItem.searchResult(emoji)
        let labeled = EmojiPickerItem.labeled(emoji)
        let empty = EmojiPickerItem.empty

        XCTAssertNotEqual(recentlyUsed, searchResult)
        XCTAssertNotEqual(recentlyUsed, labeled)
        XCTAssertNotEqual(recentlyUsed, empty)
        XCTAssertNotEqual(searchResult, labeled)
        XCTAssertNotEqual(searchResult, empty)
        XCTAssertNotEqual(labeled, empty)

        let recentlyUsed2 = EmojiPickerItem.recentlyUsed(emoji)
        let searchResult2 = EmojiPickerItem.searchResult(emoji)
        let labeled2 = EmojiPickerItem.labeled(emoji)
        let empty2 = EmojiPickerItem.empty

        XCTAssertEqual(recentlyUsed, recentlyUsed2)
        XCTAssertEqual(searchResult, searchResult2)
        XCTAssertEqual(labeled, labeled2)
        XCTAssertEqual(empty, empty2)

    }

    func testItemIdentityWhenDifferenceCharacter() throws {

        let recentlyUsed = EmojiPickerItem.recentlyUsed(Emoji("😍"))
        let searchResult = EmojiPickerItem.searchResult(Emoji("🍎"))
        let labeled = EmojiPickerItem.labeled(Emoji("🚜"))
        let empty = EmojiPickerItem.empty // It doesn't have an emoji.

        XCTAssertNotEqual(recentlyUsed, searchResult)
        XCTAssertNotEqual(recentlyUsed, labeled)
        XCTAssertNotEqual(recentlyUsed, empty)
        XCTAssertNotEqual(searchResult, labeled)
        XCTAssertNotEqual(searchResult, empty)
        XCTAssertNotEqual(labeled, empty)

        let recentlyUsed2 = EmojiPickerItem.recentlyUsed(Emoji("❤️"))
        let searchResult2 = EmojiPickerItem.searchResult(Emoji("💾"))
        let labeled2 = EmojiPickerItem.labeled(Emoji("📊"))
        let empty2 = EmojiPickerItem.empty // It doesn't have an emoji.


        XCTAssertNotEqual(recentlyUsed, recentlyUsed2)
        XCTAssertNotEqual(searchResult, searchResult2)
        XCTAssertNotEqual(labeled, labeled2)
        XCTAssertEqual(empty, empty2)

    }


}
#endif
