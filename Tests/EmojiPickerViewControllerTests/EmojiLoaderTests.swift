//
//  EmojiLoaderTests.swift
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
import Foundation
@testable import EmojiPickerViewController

// Emoji Counts: https://unicode.org/emoji/charts/emoji-counts.html

let totalEmojiCounts =            3633 // Structure
let cEmojiCounts =                1354 // Ⓒ
let cSkinTonedEmojiCounts =       645  // Ⓒ ‧ 🟫
let zHairEmojiCounts =            12   // Ⓩ ‧ 🦰
let zHairSkinTonedEmojiCounts =   60   // Ⓩ ‧ 🦰 ‧ 🟫
let zGenderEmojiCounts =          102  // Ⓩ ‧ ♀
let zGenderSkinTonedEmojiCounts = 470  // Ⓩ ‧ ♀ ‧ 🟫
let zRoleEmojiCounts =            60   // Ⓩ ‧ 👩
let zRoleSkinTonedEmojiCounts =   300  // Ⓩ ‧ 👩 ‧ 🟫
let zFamilyEmojiCounts =          32   // Ⓩ ‧ 👪
let zFamilySkinTonedEmojiCounts = 235  // Ⓩ ‧ 👪 ‧ 🟫
let zSkinTonedEmojiCounts =       65   // Ⓩ ‧ 🟫
let zcEmojiCounts =               13   // Ⓩ ‧ Ⓒ
let emojiKeycapSequenceCounts =   12   // #️⃣
let emojiFlagSequenceCounts =     258  // 🏁
let emojiTagSequenceCounts =      3    // 🏴
let componentCounts =             9    // 🔗

// SkinToned emojis are added in `orderedSkinToneEmojis` and will be shown in the emoji-variation popover.
let emojiCountsForShowingInKeyboard = totalEmojiCounts
- cSkinTonedEmojiCounts
- zHairSkinTonedEmojiCounts
- zGenderSkinTonedEmojiCounts
- zRoleSkinTonedEmojiCounts
- zFamilySkinTonedEmojiCounts
- zSkinTonedEmojiCounts
- componentCounts

// grep \; PathToProject/EmojiPickerViewController/Sources/EmojiPickerViewController/Resources/emoji-test.txt | wc -l
// > 4703
// -1 is a consideration for header comment of `emoji-text.txt`
let emojiCountsListedInEmojiTest = 4702

@Suite
@MainActor struct EmojiLoaderTests {

    // MARK: - Testing EmojiLoader

    @Test
    func load() throws {

        let loader = EmojiLoader()
        loader.load()
        let entireEmojiSet = loader.entireEmojiSet
        let labeledEmojisForKeyboard = loader.labeledEmojisForKeyboard

                
        /*
         The dictionary and array only include emoji which are valid on the system
         */
        #expect(entireEmojiSet.values.allSatisfy({ $0.character.unicodeScalars.first?.properties.isEmoji == true }))
        #expect(labeledEmojisForKeyboard.values.joined().allSatisfy({ $0.character.unicodeScalars.first?.properties.isEmoji == true }))

        /*
         The dictionary and array has expected number of emoji
         */
        #expect(entireEmojiSet.count == emojiCountsListedInEmojiTest)
        #expect(labeledEmojisForKeyboard.values.joined().count == emojiCountsForShowingInKeyboard)

        /*
         The reference of an emoji is shared both Array and Dictionary?
         */
        let face = try #require(labeledEmojisForKeyboard[.smileysPeople]?.first)

        #expect(face.character == "😀")
        #expect(face.cldrOrder == 0)
        #expect(face.group == "Smileys & Emotion")
        #expect(face.subgroup == "face-smiling")

        let flag = try #require((labeledEmojisForKeyboard[.flags]?.last))

        #expect(flag.character == "🏴󠁧󠁢󠁷󠁬󠁳󠁿")
        #expect(flag.cldrOrder == emojiCountsListedInEmojiTest - 1) // the order starts from 0.
        #expect(flag.group == "Flags")
        #expect(flag.subgroup == "subdivision-flag")

        let grinningFace = Character(exactly: "1F600")
        #expect(entireEmojiSet[grinningFace]?.character == "😀")
        #expect(entireEmojiSet[grinningFace]?.cldrOrder == 0)
        #expect(entireEmojiSet[grinningFace]?.group == "Smileys & Emotion")
        #expect(entireEmojiSet[grinningFace]?.subgroup == "face-smiling")

        let flagWales = Character(exactly: "1F3F4 E0067 E0062 E0077 E006C E0073 E007F")
        #expect(entireEmojiSet[flagWales]?.character == "🏴󠁧󠁢󠁷󠁬󠁳󠁿")
        #expect(entireEmojiSet[flagWales]?.cldrOrder == emojiCountsListedInEmojiTest - 1) // the order starts from 0.

        #expect(entireEmojiSet[flagWales]?.group == "Flags")
        #expect(entireEmojiSet[flagWales]?.subgroup == "subdivision-flag")

        /*
         An emoji that doesn't have any variations
        */
        
        // Assert For Variation Base
        let kissMarkCharacter = Character(exactly: "1F48B")
        let kissMarkEmoji = try #require(entireEmojiSet[kissMarkCharacter])
        #expect(kissMarkEmoji.character == "💋")

        // Assert for Qualified Variations
        #expect(kissMarkEmoji.fullyQualifiedVersion == nil)
        #expect(kissMarkEmoji.minimallyQualifiedOrUnqualifiedVersions.isEmpty)

        // Assert For Modifier Sequence Variations
        #expect(kissMarkEmoji.genericSkinToneEmoji == nil)
        #expect(kissMarkEmoji.orderedSkinToneEmojis.isEmpty)

        /*
        An emoji that has modifier sequence's variation, but no qualified variations
         */
        
        // Assert For Variation Base
        let victoryHandCharacter = Character(exactly: "1F90F")
        let victoryHandEmoji = try #require(entireEmojiSet[victoryHandCharacter])
        #expect(victoryHandEmoji.character == "🤏")

        // Assert for Qualified Variations
        #expect(victoryHandEmoji.fullyQualifiedVersion == nil)
        #expect(victoryHandEmoji.minimallyQualifiedOrUnqualifiedVersions.isEmpty)

        // Assert For Modifier Sequence Variations
        let expectedSkintoneVariations = [
            Character(exactly: "1F90F 1F3FB"), // 🤏🏻
            Character(exactly: "1F90F 1F3FC"), // 🤏🏼
            Character(exactly: "1F90F 1F3FD"), // 🤏🏽
            Character(exactly: "1F90F 1F3FE"), // 🤏🏾
            Character(exactly: "1F90F 1F3FF")  // 🤏🏿
        ]

        #expect(victoryHandEmoji.genericSkinToneEmoji == nil)
        #expect(victoryHandEmoji.orderedSkinToneEmojis.count == 5)

        for (index, skinTonedEmoji) in victoryHandEmoji.orderedSkinToneEmojis.enumerated() {
            #expect(skinTonedEmoji.character == expectedSkintoneVariations[index])
            #expect(skinTonedEmoji.fullyQualifiedVersion == nil)
            #expect(skinTonedEmoji.minimallyQualifiedOrUnqualifiedVersions.isEmpty)
            #expect(skinTonedEmoji.genericSkinToneEmoji == victoryHandEmoji)
            #expect(skinTonedEmoji.orderedSkinToneEmojis.isEmpty)
        }

        /*
         An emoji that has qualified, but no variationsmodifier sequence's variations
         */
        
        // Assert For Variation Base
        let passengerShipCharacter = Character(exactly: "1F6F3 FE0F")
        let passengerShipEmoji = try #require(entireEmojiSet[passengerShipCharacter])
        #expect(passengerShipEmoji.character == "🛳️")

        // Assert for Qualified Variations
        #expect(passengerShipEmoji.fullyQualifiedVersion == nil)
        #expect(passengerShipEmoji.minimallyQualifiedOrUnqualifiedVersions.count == 1)

        let qualifiedVariation = passengerShipEmoji.minimallyQualifiedOrUnqualifiedVersions[0]
        #expect(qualifiedVariation.fullyQualifiedVersion == passengerShipEmoji)
        #expect(qualifiedVariation.minimallyQualifiedOrUnqualifiedVersions.isEmpty)
        #expect(qualifiedVariation.genericSkinToneEmoji == nil)
        #expect(qualifiedVariation.orderedSkinToneEmojis.isEmpty)

        // Assert For Modifier Sequence Variations
        #expect(passengerShipEmoji.genericSkinToneEmoji == nil)
        #expect(passengerShipEmoji.orderedSkinToneEmojis.isEmpty)

        /*
         An emoji that has both modifier sequences's variations and qualified variations.
         */
        // Assert For Variation Base
        let manDetectiveCharacter = Character(exactly: "1F575 FE0F 200D 2642 FE0F")
        let manDetectiveEmoji = try #require(entireEmojiSet[manDetectiveCharacter])
        #expect(manDetectiveEmoji.character == Character(exactly: "1F575 FE0F 200D 2642 FE0F")) // 🕵️‍♂️

        // Assert for Qualified Variations
        #expect(manDetectiveEmoji.fullyQualifiedVersion == nil)
        #expect(manDetectiveEmoji.minimallyQualifiedOrUnqualifiedVersions.count == 3)

        let expectedQualifiedVariations = [
            Character(exactly: "1F575 200D 2642 FE0F"), // 🕵‍♂️
            Character(exactly: "1F575 FE0F 200D 2642"), // 🕵️‍♂
            Character(exactly: "1F575 200D 2642")       // 🕵‍♂
        ]

        for (index, qualifiedVariation) in manDetectiveEmoji.minimallyQualifiedOrUnqualifiedVersions.enumerated() {
            #expect(qualifiedVariation.character == expectedQualifiedVariations[index])
            #expect(qualifiedVariation.fullyQualifiedVersion == manDetectiveEmoji)
            #expect(qualifiedVariation.minimallyQualifiedOrUnqualifiedVersions.isEmpty)
            #expect(qualifiedVariation.genericSkinToneEmoji == nil)
            #expect(qualifiedVariation.orderedSkinToneEmojis.isEmpty)
        }

        // Assert For Modifier Sequence Variations
        #expect(manDetectiveEmoji.genericSkinToneEmoji == nil)
        #expect(manDetectiveEmoji.orderedSkinToneEmojis.count == 5)

        let expectedSkintoneVariationssWithItsQualifiedVariation: [(Character, Character)] = [
            (Character(exactly: "1F575 1F3FB 200D 2642 FE0F"), Character(exactly: "1F575 1F3FB 200D 2642")), // 🕵🏻‍♂️, 🕵🏻‍♂
            (Character(exactly: "1F575 1F3FC 200D 2642 FE0F"), Character(exactly: "1F575 1F3FC 200D 2642")), // 🕵🏼‍♂️, 🕵🏼‍♂
            (Character(exactly: "1F575 1F3FD 200D 2642 FE0F"), Character(exactly: "1F575 1F3FD 200D 2642")), // 🕵🏽‍♂, 🕵🏽‍♂
            (Character(exactly: "1F575 1F3FE 200D 2642 FE0F"), Character(exactly: "1F575 1F3FE 200D 2642")), // 🕵🏾‍♂️, 🕵🏽‍♂
            (Character(exactly: "1F575 1F3FF 200D 2642 FE0F"), Character(exactly: "1F575 1F3FF 200D 2642")), // 🕵🏾‍♂️, 🕵🏽‍♂
        ]

        for (index, skintoneVariation) in manDetectiveEmoji.orderedSkinToneEmojis.enumerated() {
            #expect(skintoneVariation.character == expectedSkintoneVariationssWithItsQualifiedVariation[index].0)
            #expect(skintoneVariation.genericSkinToneEmoji == manDetectiveEmoji)
            #expect(skintoneVariation.orderedSkinToneEmojis.isEmpty)
            #expect(skintoneVariation.fullyQualifiedVersion == nil)

            #expect(skintoneVariation.minimallyQualifiedOrUnqualifiedVersions.count == 1)
            let qualifiedVariation = skintoneVariation.minimallyQualifiedOrUnqualifiedVersions[0]
            #expect(qualifiedVariation.character == expectedSkintoneVariationssWithItsQualifiedVariation[index].1)
            #expect(qualifiedVariation.fullyQualifiedVersion == skintoneVariation)
            #expect(qualifiedVariation.minimallyQualifiedOrUnqualifiedVersions.isEmpty)
            #expect(qualifiedVariation.genericSkinToneEmoji == nil)
            #expect(qualifiedVariation.orderedSkinToneEmojis.isEmpty)

        }
    }

    // MARK: - Testing EmojiLoader.Row

    @Test
    func initCommentRow() {
        let line = "# This is test comment"
        let row = EmojiLoader.Row(line)
        #expect(row == .comment)
    }

    @Test
    func initUnformatedRowFailOver() {
        let line = "こんにちわ！"
        let row = EmojiLoader.Row(line)
        #expect(row == .comment)
    }

    @Test
    func initGroupHeaderRow() {
        let line = "# group: Smileys & Emotion"
        let row = EmojiLoader.Row(line)
        #expect(row == .groupHeader(groupName: "Smileys & Emotion"))
    }

    @Test
    func initGroupHeaderRowFailOver() {
        let line = "# group:"
        let row = EmojiLoader.Row(line)
        #expect(row == .comment)
    }

    @Test
    func initSubgroupHeaderRow() {
        let line = "# subgroup: face-smiling"
        let row = EmojiLoader.Row(line)
        #expect(row == .subgroupHeader(suggroupName: "face-smiling"))
    }

    @Test
    func initSubgroupHeaderFailOver() {
        let line = "# subgroup:"
        let row = EmojiLoader.Row(line)
        #expect(row == .comment)
    }

    // MARK: - Testing EmojiLoader.Data

    @Test
    func initDataWhenFullyQualified() throws {
        let dataRowString = """
        1F93E 200D 2642 FE0F                                   ; fully-qualified     # 🤾‍♂️ E4.0 man playing handball
        """
        let data = try #require(EmojiLoader.Data(dataRowString: dataRowString))
        #expect(data.unicodeScalars.map({ $0.value }) == [
            UInt32("1F93E", radix: 16)!,
            UInt32("200D", radix: 16)!,
            UInt32("2642", radix: 16)!,
            UInt32("FE0F", radix: 16)!
        ])
        #expect(data.status == .fullyQualified)
    }

    @Test
    func initDataWhenMinimallyQualified() throws {
        let dataRowString = """
        26F9 1F3FF 200D 2642                                   ; minimally-qualified # ⛹🏿‍♂ E4.0 man bouncing ball: dark skin tone
        """
        let data = try #require(EmojiLoader.Data(dataRowString: dataRowString))
        #expect(data.unicodeScalars.map({ $0.value }) == [
            UInt32("26F9", radix: 16)!,
            UInt32("1F3FF", radix: 16)!,
            UInt32("200D", radix: 16)!,
            UInt32("2642", radix: 16)!
        ])
        #expect(data.status == .minimallyQualified)
    }

    @Test
    func initDataWhenUnqualified() throws {
        let dataRowString = """
        1F575                                                  ; unqualified         # 🕵 E0.7 detective
        """
        let data = try #require(EmojiLoader.Data(dataRowString: dataRowString))
        #expect(data.unicodeScalars.map({ $0.value }) == [
            UInt32("1F575", radix: 16)!,
        ])
        #expect(data.status == .unqualified)
    }

    @Test
    func initDataWhenComponent() throws {
        let dataRowString = """
        1F3FB                                                  ; component           # 🏻 E1.0 light skin tone
        """
        let data = try #require(EmojiLoader.Data(dataRowString: dataRowString))
        #expect(data.unicodeScalars.map({ $0.value }) == [
            UInt32("1F3FB", radix: 16)!,
        ])
        #expect(data.status == .component)
    }

    @Test
    func initDataWhenCommentNotFound() throws {
        let dataRowString = """
        1F469 200D 2764 FE0F 200D 1F48B 200D 1F469             ; fully-qualified
        """
        let data = try #require(EmojiLoader.Data(dataRowString: dataRowString))
        #expect(data.unicodeScalars == ["\u{1F469}", "\u{200D}", "\u{2764}", "\u{FE0F}", "\u{200D}", "\u{1F48B}", "\u{200D}", "\u{1F469}"])
        #expect(data.status == .fullyQualified)
    }

}

extension Character {

    // Such as 1F575 1F3FB 200D 2642
    init(exactly hexString: String) {
        let unicodeScalars: [Unicode.Scalar] = hexString.split(separator: " ").compactMap({ UInt32($0, radix: 16) }).compactMap({ Unicode.Scalar($0) })
        let unicodeScalarView = Character.UnicodeScalarView(unicodeScalars)
        self.init(String(unicodeScalarView))
    }

}

#if !os(Linux)
import XCTest

@MainActor
class EmojiLoaderPerformanceTests: XCTestCase {
    
    func testPerformanceLoad() throws {
        
        let loader = EmojiLoader()
        
        // loader.load() should be finished less than 0.1sec.
        self.measure {
            loader.load()
        }
        
    }

}
#endif
