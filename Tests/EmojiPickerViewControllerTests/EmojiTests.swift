//
//  EmojiTests.swift
//  
//  EmojiPickerViewController
//  https://github.com/yosshi4486/EmojiPickerViewController
//
//  Created by yosshi4486 on 2022/01/31.
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

class EmojiTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testIsEmojiModifierSequenceWhenSigletonEmojiCharacter() throws {

        // 1F44C
        let emoji = Emoji(character: "👌", recommendedOrder: 0, group: "", subgroup: "")
        XCTAssertFalse(emoji.isEmojiModifierSequence)

    }

    func testIsEmojiModifierSequenceWhenEmojiZWJSequence() throws {

        // 1F635 200D 1F4AB
        let emoji = Emoji(character: "😵‍💫", recommendedOrder: 0, group: "", subgroup: "")
        XCTAssertFalse(emoji.isEmojiModifierSequence)

    }

    func testIsEmojiModifierSequenceWhenSinglePersonSkinTones() throws {

        // 1F44C 1F3FC
        let emoji = Emoji(character: "👌🏼", recommendedOrder: 0, group: "", subgroup: "")
        XCTAssertTrue(emoji.isEmojiModifierSequence)

    }

    func testIsEmojiModifierSequenceWhenMultiPersonSkinTones() throws {

        // 1F9D1 1F3FB 200D 2764 FE0F 200D 1F48B 200D 1F9D1 1F3FC
        let emoji = Emoji(character: "🧑🏻‍❤️‍💋‍🧑🏼", recommendedOrder: 0, group: "", subgroup: "")
        XCTAssertTrue(emoji.isEmojiModifierSequence)

    }

}
