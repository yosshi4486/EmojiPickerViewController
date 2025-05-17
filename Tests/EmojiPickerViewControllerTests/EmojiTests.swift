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

import Testing
@testable import EmojiPickerViewController

@Suite
struct EmojiTests {

    @Test
    func id() {
        let emoji = Emoji("👌🏼")
        #expect(emoji.id == "👌🏼")
    }

    @Suite
    struct EqualTests {
        @Test
        func equal() {
            let emojiA = Emoji("👌", status: .fullyQualified, cldrOrder: 0, group: "A", subgroup: "A")
            let emojiB = Emoji("👌", status: .unqualified, cldrOrder: 10, group: "B", subgroup: "B")
            #expect(emojiA == emojiB)
        }

        @Test
        func notEqual() {
            let emojiA = Emoji("👌", status: .fullyQualified, cldrOrder: 0, group: "Dif", subgroup: "Dif")
            let emojiB = Emoji("😵‍💫", status: .fullyQualified, cldrOrder: 0, group: "Dif", subgroup: "Dif")
            #expect(emojiA != emojiB)
        }
    }

    @Suite
    struct HashTests {
        @Test
        func sameHash() {
            let emojiA = Emoji("👌", status: .fullyQualified, cldrOrder: 0, group: "A", subgroup: "A")
            let emojiB = Emoji("👌", status: .unqualified, cldrOrder: 10, group: "B", subgroup: "B")
            #expect(emojiA.hashValue == emojiB.hashValue)
        }

        @Test
        func differentHash() {
            let emojiA = Emoji("👌", status: .fullyQualified, cldrOrder: 0, group: "Dif", subgroup: "Dif")
            let emojiB = Emoji("😵‍💫", status: .fullyQualified, cldrOrder: 0, group: "Dif", subgroup: "Dif")
            #expect(emojiA.hashValue != emojiB.hashValue)
        }
    }

    @Test
    func description() {
        let emoji = Emoji("⛹🏿‍♀", status: .minimallyQualified, cldrOrder: 2360, group: "People & Body", subgroup: "person-sport")
        emoji.annotation = "ball | dark skin tone | woman | woman bouncing ball"
        emoji.textToSpeech = "woman bouncing ball: dark skin tone"

        let expectedText = """
        <Emoji: character=⛹🏿‍♀ status=minimallyQualified cldrOrder=2360 group=People & Body subgroup=person-sport annotation=ball | dark skin tone | woman | woman bouncing ball textToSpeech=woman bouncing ball: dark skin tone orderedSkinToneEmojis=[] genericSkinToneEmoji=nil minimallyQualifiedOrUnqualifiedVersions=[] fullyQualifiedVersion=nil>
        """
        #expect(emoji.description == expectedText)
    }

    @Suite
    struct IsEmojiModifierSequenceTests {
        @Test
        func singletonEmoji() {
            let emoji = Emoji("👌")
            #expect(emoji.isEmojiModifierSequence == false)
        }

        @Test
        func emojiZWJSequence() {
            let emoji = Emoji("😵‍💫")
            #expect(emoji.isEmojiModifierSequence == false)
        }

        @Test
        func singlePersonSkinTonedEmoji() {
            let emoji = Emoji("👌🏼")
            #expect(emoji.isEmojiModifierSequence)
        }

        @Test
        func multiplePersonSkinTonedEmoji() {
            let emoji = Emoji("🧑🏻‍❤️‍💋‍🧑🏼")
            #expect(emoji.isEmojiModifierSequence)
        }
    }

    @Suite
    struct InitStatusTests {
        @Test
        func component() {
            #expect(Emoji.Status(rawValue: "component") == .component)
        }

        @Test
        func fullyQualified() {
            #expect(Emoji.Status(rawValue: "fully-qualified") == .fullyQualified)
        }

        @Test
        func minimallyQualified() {
            #expect(Emoji.Status(rawValue: "minimally-qualified") == .minimallyQualified)
        }

        @Test
        func unqualified() {
            #expect(Emoji.Status(rawValue: "unqualified") == .unqualified)
        }

        @Test
        func unknown() {
            #expect(Emoji.Status(rawValue: "unknown") == nil)
        }
    }


}
