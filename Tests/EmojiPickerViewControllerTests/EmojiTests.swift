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

    func testIsEmojiModifierSequence() throws {

        XCTContext.runActivity(named: "Singleton Emoji") { _ in

            // 1F44C
            let emoji = Emoji(character: "👌", recommendedOrder: 0, group: "", subgroup: "")
            XCTAssertFalse(emoji.isEmojiModifierSequence)

        }

        XCTContext.runActivity(named: "Emoji ZWJ Sequence") { _ in

            // 1F635 200D 1F4AB
            let emoji = Emoji(character: "😵‍💫", recommendedOrder: 0, group: "", subgroup: "")
            XCTAssertFalse(emoji.isEmojiModifierSequence)

        }

        XCTContext.runActivity(named: "Single Person Skin Toned Emoji") { _ in

            // 1F44C 1F3FC
            let emoji = Emoji(character: "👌🏼", recommendedOrder: 0, group: "", subgroup: "")
            XCTAssertTrue(emoji.isEmojiModifierSequence)

        }

        XCTContext.runActivity(named: "Multiple Person Skin Toned Emoji") { _ in

            // 1F9D1 1F3FB 200D 2764 FE0F 200D 1F48B 200D 1F9D1 1F3FC
            let emoji = Emoji(character: "🧑🏻‍❤️‍💋‍🧑🏼", recommendedOrder: 0, group: "", subgroup: "")
            XCTAssertTrue(emoji.isEmojiModifierSequence)

        }

    }

    func testLocalizedLabel() throws {

        XCTContext.runActivity(named: "Group: Smileys & Emotion") { _ in

            // 1F600
            let emoji = Emoji(character: "😀", recommendedOrder: 0, group: "Smileys & Emotion", subgroup: "face-smiling")
            let key = "smileys_people"
            XCTAssertNotEqual(emoji.localizedLabel, key)
            XCTAssertEqual(emoji.localizedLabel, NSLocalizedString(key, bundle: .module, comment: ""))

            print("The localized label for \(emoji.character) is \(String(describing: emoji.localizedLabel))")

        }

        XCTContext.runActivity(named: "Group: People & Body") { _ in

            // 1F44B
            let emoji = Emoji(character: "👋", recommendedOrder: 0, group: "People & Body", subgroup: "hand-fingers-open")
            let key = "smileys_people"
            XCTAssertNotEqual(emoji.localizedLabel, key)
            XCTAssertEqual(emoji.localizedLabel, NSLocalizedString(key, bundle: .module, comment: ""))

            print("The localized label for \(emoji.character) is \(String(describing: emoji.localizedLabel))")

        }

        XCTContext.runActivity(named: "Group: Food & Drink") { _ in

            // 1F347
            let emoji = Emoji(character: "🍇", recommendedOrder: 0, group: "Food & Drink", subgroup: "food-fruit")
            let key = "food_drink"
            XCTAssertNotEqual(emoji.localizedLabel, key)
            XCTAssertEqual(emoji.localizedLabel, NSLocalizedString(key, bundle: .module, comment: ""))

            print("The localized label for \(emoji.character) is \(String(describing: emoji.localizedLabel))")

        }

        XCTContext.runActivity(named: "Group: Travel & Places") { _ in

            // 1F30D
            let emoji = Emoji(character: "🌍", recommendedOrder: 0, group: "Travel & Places", subgroup: "place-map")
            let key = "travel_places"
            XCTAssertNotEqual(emoji.localizedLabel, key)
            XCTAssertEqual(emoji.localizedLabel, NSLocalizedString(key, bundle: .module, comment: ""))

            print("The localized label for \(emoji.character) is \(String(describing: emoji.localizedLabel))")

        }

        XCTContext.runActivity(named: "Group: Activities") { _ in

            // 1F383
            let emoji = Emoji(character: "🎃", recommendedOrder: 0, group: "Activities", subgroup: "event")
            let key = "activities"
            XCTAssertNotEqual(emoji.localizedLabel, key)
            XCTAssertEqual(emoji.localizedLabel, NSLocalizedString(key, bundle: .module, comment: ""))

            print("The localized label for \(emoji.character) is \(String(describing: emoji.localizedLabel))")

        }

        XCTContext.runActivity(named: "Group: Objects") { _ in

            // 1F453
            let emoji = Emoji(character: "👓", recommendedOrder: 0, group: "Objects", subgroup: "clothing")
            let key = "objects"
            XCTAssertNotEqual(emoji.localizedLabel, key)
            XCTAssertEqual(emoji.localizedLabel, NSLocalizedString(key, bundle: .module, comment: ""))

            print("The localized label for \(emoji.character) is \(String(describing: emoji.localizedLabel))")

        }

        XCTContext.runActivity(named: "Group: Symbols") { _ in

            // 1F3E7
            let emoji = Emoji(character: "🏧", recommendedOrder: 0, group: "Symbols", subgroup: "transport-sign")
            let key = "symbols"
            XCTAssertNotEqual(emoji.localizedLabel, key)
            XCTAssertEqual(emoji.localizedLabel, NSLocalizedString(key, bundle: .module, comment: ""))

            print("The localized label for \(emoji.character) is \(String(describing: emoji.localizedLabel))")

        }

        XCTContext.runActivity(named: "Group: Flags") { _ in

            // 1F38C
            let emoji = Emoji(character: "🎌", recommendedOrder: 0, group: "Flags", subgroup: "country-flag")
            let key = "flags"
            XCTAssertNotEqual(emoji.localizedLabel, key)
            XCTAssertEqual(emoji.localizedLabel, NSLocalizedString(key, bundle: .module, comment: ""))

            print("The localized label for \(emoji.character) is \(String(describing: emoji.localizedLabel))")

        }


    }


}
