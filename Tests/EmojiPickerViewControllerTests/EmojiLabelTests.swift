//
//  EmojiLabelTests.swift
//
//  EmojiPickerViewController
//  https://github.com/yosshi4486/EmojiPickerViewController
//
//  Created by yosshi4486 on 2022/02/05.
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
class EmojiLabelTests {

    @Test
    func localizedDescription() throws {

        let label1 = EmojiLabel(group: "Smileys & Emotion")
        #expect(label1 == .smileysPeople)

        let label2 = EmojiLabel(group: "People & Body")
        #expect(label2 == .smileysPeople)

        let label3 = EmojiLabel(group: "Food & Drink")
        #expect(label3 == .foodDrink)

        let label4 = EmojiLabel(group: "Travel & Places")
        #expect(label4 == .travelPlaces)

        let label5 = EmojiLabel(group: "Activities")
        #expect(label5 == .activities)

        let label6 = EmojiLabel(group: "Objects")
        #expect(label6 == .objects)

        let label7 = EmojiLabel(group: "Symbols")
        #expect(label7 == .symbols)

        let label8 = EmojiLabel(group: "Flags")
        #expect(label8 == .flags)

    }

}
