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

import Testing
@testable import EmojiPickerViewController

@Suite("EmojiPickerSectionTests")
struct EmojiPickerSectionTests {

    @Test
    func testInitFromIndex() throws {
        #expect(EmojiPickerSection(index: -1) == nil)
        #expect(EmojiPickerSection(index: 0) == .frequentlyUsed(.recentlyUsed))
        #expect(EmojiPickerSection(index: 1) == .frequentlyUsed(.searchResult))
        #expect(EmojiPickerSection(index: 2) == .smileysPeople)
        #expect(EmojiPickerSection(index: 3) == .animalsNature)
        #expect(EmojiPickerSection(index: 4) == .foodDrink)
        #expect(EmojiPickerSection(index: 5) == .travelPlaces)
        #expect(EmojiPickerSection(index: 6) == .activities)
        #expect(EmojiPickerSection(index: 7) == .objects)
        #expect(EmojiPickerSection(index: 8) == .symbols)
        #expect(EmojiPickerSection(index: 9) == .flags)
        #expect(EmojiPickerSection(index: 10) == nil)
    }

    @Test
    func testInitFromLabel() throws {

        #expect(EmojiPickerSection(emojiLabel: .smileysPeople) == .smileysPeople)
        #expect(EmojiPickerSection(emojiLabel: .foodDrink) == .foodDrink)
        #expect(EmojiPickerSection(emojiLabel: .travelPlaces) == .travelPlaces)
        #expect(EmojiPickerSection(emojiLabel: .activities) == .activities)
        #expect(EmojiPickerSection(emojiLabel: .objects) == .objects)
        #expect(EmojiPickerSection(emojiLabel: .symbols) == .symbols)
        #expect(EmojiPickerSection(emojiLabel: .flags) == .flags)

    }

    @Test
    func testLocalizedSectionName() throws {

        // Tests boolean whether the returned string is not equal to the key, if it is equal key, the implementation or localization file has miss.
        #expect(EmojiPickerSection.frequentlyUsed(.recentlyUsed).localizedSectionName != "recently_used")
        #expect(EmojiPickerSection.frequentlyUsed(.searchResult).localizedSectionName != "search_result")
        #expect(EmojiPickerSection.frequentlyUsed(.recentlyUsed).localizedSectionName != EmojiPickerSection.frequentlyUsed(.searchResult).localizedSectionName)
        #expect(EmojiPickerSection.smileysPeople.localizedSectionName != "smileys_people")
        #expect(EmojiPickerSection.foodDrink.localizedSectionName != "food_drink")
        #expect(EmojiPickerSection.travelPlaces.localizedSectionName != "travel_places")
        #expect(EmojiPickerSection.activities.localizedSectionName != "activities")
        #expect(EmojiPickerSection.objects.localizedSectionName != "objects")
        #expect(EmojiPickerSection.symbols.localizedSectionName != "symbols")
        #expect(EmojiPickerSection.flags.localizedSectionName != "fllags")

    }

}
