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

    func testID() throws {

        let emoji = Emoji("👌🏼")
        XCTAssertEqual(emoji.id, "👌🏼")

    }

    func testEqual() throws {

        XCTContext.runActivity(named: "Equal") { _ in
            let emojiA = Emoji("👌", status: .fullyQualified, cldrOrder: 0, group: "A", subgroup: "A")
            let emojiB = Emoji("👌", status: .unqualified, cldrOrder: 10, group: "B", subgroup: "B")
            XCTAssertEqual(emojiA, emojiB)
        }

        XCTContext.runActivity(named: "Not Equal") { _ in
            let emojiA = Emoji("👌", status: .fullyQualified, cldrOrder: 0, group: "Dif", subgroup: "Dif")
            let emojiB = Emoji("😵‍💫", status: .fullyQualified, cldrOrder: 0, group: "Dif", subgroup: "Dif")
            XCTAssertNotEqual(emojiA, emojiB)
        }

    }

    func testHash() throws {

        XCTContext.runActivity(named: "Same hash") { _ in
            let emojiA = Emoji("👌", status: .fullyQualified, cldrOrder: 0, group: "A", subgroup: "A")
            let emojiB = Emoji("👌", status: .unqualified, cldrOrder: 10, group: "B", subgroup: "B")
            XCTAssertEqual(emojiA.hashValue, emojiB.hashValue)
        }

        XCTContext.runActivity(named: "Different hash") { _ in
            let emojiA = Emoji("👌", status: .fullyQualified, cldrOrder: 0, group: "Dif", subgroup: "Dif")
            let emojiB = Emoji("😵‍💫", status: .fullyQualified, cldrOrder: 0, group: "Dif", subgroup: "Dif")
            XCTAssertNotEqual(emojiA.hashValue, emojiB.hashValue)
        }

    }

    func testDescription() throws {

        let emoji = Emoji("⛹🏿‍♀", status: .minimallyQualified, cldrOrder: 2360, group: "People & Body", subgroup: "person-sport")
        emoji.annotation = "ball | dark skin tone | woman | woman bouncing ball"
        emoji.textToSpeach = "woman bouncing ball: dark skin tone"

        let expectedText = """
        <Emoji:\(Unmanaged.passUnretained(emoji).toOpaque()) character=⛹🏿‍♀ status=minimallyQualified cldrOrder=2360 group=People & Body subgroup=person-sport annotation=ball | dark skin tone | woman | woman bouncing ball textToSpeach=woman bouncing ball: dark skin tone genericSkinToneEmoji=nil orderedSkinToneEmojis=[] fullyQualifiedVersion=nil minimallyQualifiedOrUnqualifiedVersions=[]>
        """
        XCTAssertEqual(emoji.description, expectedText)

    }

    func testIsEmojiModifierSequence() throws {

        XCTContext.runActivity(named: "Singleton Emoji") { _ in

            // 1F44C
            let emoji = Emoji("👌")
            XCTAssertFalse(emoji.isEmojiModifierSequence)

        }

        XCTContext.runActivity(named: "Emoji ZWJ Sequence") { _ in

            // 1F635 200D 1F4AB
            let emoji = Emoji("😵‍💫")
            XCTAssertFalse(emoji.isEmojiModifierSequence)

        }

        XCTContext.runActivity(named: "Single Person Skin Toned Emoji") { _ in

            // 1F44C 1F3FC
            let emoji = Emoji("👌🏼")
            XCTAssertTrue(emoji.isEmojiModifierSequence)

        }

        XCTContext.runActivity(named: "Multiple Person Skin Toned Emoji") { _ in

            // 1F9D1 1F3FB 200D 2764 FE0F 200D 1F48B 200D 1F9D1 1F3FC
            let emoji = Emoji("🧑🏻‍❤️‍💋‍🧑🏼")
            XCTAssertTrue(emoji.isEmojiModifierSequence)

        }

    }

    // MARK: - Testing Emoji.Status

    func testInitStatus() throws {

        XCTContext.runActivity(named: "component") { _ in
            XCTAssertEqual(Emoji.Status(rawValue: "component"), .component)
        }

        XCTContext.runActivity(named: "fully qualified") { _ in
            XCTAssertEqual(Emoji.Status(rawValue: "fully-qualified"), .fullyQualified)
        }

        XCTContext.runActivity(named: "minimally qualified") { _ in
            XCTAssertEqual(Emoji.Status(rawValue: "minimally-qualified"), .minimallyQualified)
        }

        XCTContext.runActivity(named: "unqualified") { _ in
            XCTAssertEqual(Emoji.Status(rawValue: "unqualified"), .unqualified)
        }

        XCTContext.runActivity(named: "unknown") { _ in
            XCTAssertNil(Emoji.Status(rawValue: "unknown"))
        }

    }


}
