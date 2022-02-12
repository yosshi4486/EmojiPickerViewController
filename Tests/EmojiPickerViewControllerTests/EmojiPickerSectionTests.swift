//
//  EmojiPickerSectionTests.swift
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
class EmojiPickerSectionTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInitFromLabel() throws {

        XCTAssertEqual(EmojiPickerSection(emojiLabel: .smileysPeople), .smileysPeople)
        XCTAssertEqual(EmojiPickerSection(emojiLabel: .foodDrink), .foodDrink)
        XCTAssertEqual(EmojiPickerSection(emojiLabel: .travelPlaces), .travelPlaces)
        XCTAssertEqual(EmojiPickerSection(emojiLabel: .activities), .activities)
        XCTAssertEqual(EmojiPickerSection(emojiLabel: .objects), .objects)
        XCTAssertEqual(EmojiPickerSection(emojiLabel: .symbols), .symbols)
        XCTAssertEqual(EmojiPickerSection(emojiLabel: .flags), .flags)

    }

    func testLocalizedSectionName() throws {

        // Tests boolean whether the returned string is not equal to the key, if it is equal key, the implementation or localization file has miss.
        XCTAssertNotEqual(EmojiPickerSection.recentlyUsed.localizedSectionName, "recently_used")
        XCTAssertNotEqual(EmojiPickerSection.searchResult.localizedSectionName, "search_result")
        XCTAssertNotEqual(EmojiPickerSection.smileysPeople.localizedSectionName, "smileys_people")
        XCTAssertNotEqual(EmojiPickerSection.foodDrink.localizedSectionName, "food_drink")
        XCTAssertNotEqual(EmojiPickerSection.travelPlaces.localizedSectionName, "travel_places")
        XCTAssertNotEqual(EmojiPickerSection.activities.localizedSectionName, "activities")
        XCTAssertNotEqual(EmojiPickerSection.objects.localizedSectionName, "objects")
        XCTAssertNotEqual(EmojiPickerSection.symbols.localizedSectionName, "symbols")
        XCTAssertNotEqual(EmojiPickerSection.flags.localizedSectionName, "fllags")

    }

}
#endif
