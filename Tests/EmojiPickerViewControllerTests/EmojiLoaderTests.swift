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

import XCTest
@testable import EmojiPickerViewController

// Emoji Counts: https://unicode.org/emoji/charts/emoji-counts.html

let totalEmojiCounts =            3633
let cEmojiCounts =                1354
let cSkinTonedEmojiCounts =       645
let zHairEmojiCounts =            12
let zHairSkinTonedEmojiCounts =   60
let zGenderEmojiCounts =          102
let zGenderSkinTonedEmojiCounts = 470
let zRoleEmojiCounts =            60
let zRoleSkinTonedEmojiCounts =   300
let zFamilyEmojiCounts =          32
let zFamilySkinTonedEmojiCounts = 235
let zSkinTonedEmojiCounts =       65
let zcEmojiCounts =               13
let emojiKeycapSequenceCounts =   12
let emojiFlagSequenceCounts =     258
let emojiTagSequenceCounts =      3
let componentCounts =             9

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

@MainActor class EmojiLoaderTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // MARK: - Testing EmojiLoader

    func testLoad() throws {

        let loader = EmojiLoader()
        loader.load()
        let dictionary = loader.wholeEmojiDictionary
        let array = loader.fullyQualifiedOrderedEmojisForKeyboard

        XCTAssertEqual(dictionary.count, emojiCountsListedInEmojiTest)
        XCTAssertEqual(array.count, emojiCountsForShowingInKeyboard)

        XCTContext.runActivity(named: "Test: The reference of an emoji is shared both Array and Dictionary") { _ in

            XCTAssertEqual(array.first?.character, "😀")
            XCTAssertEqual(array.first?.cldrOrder, 0)
            XCTAssertEqual(array.first?.group, "Smileys & Emotion")
            XCTAssertEqual(array.first?.subgroup, "face-smiling")

            XCTAssertEqual(array.last?.character, "🏴󠁧󠁢󠁷󠁬󠁳󠁿")
            XCTAssertEqual(array.last?.cldrOrder, emojiCountsListedInEmojiTest - 1) // the order starts from 0.
            XCTAssertEqual(array.last?.group, "Flags")
            XCTAssertEqual(array.last?.subgroup, "subdivision-flag")

            let grinningFace = Character(exactly: "1F600")
            XCTAssertEqual(dictionary[grinningFace]?.character, "😀")
            XCTAssertEqual(dictionary[grinningFace]?.cldrOrder, 0)
            XCTAssertEqual(dictionary[grinningFace]?.group, "Smileys & Emotion")
            XCTAssertEqual(dictionary[grinningFace]?.subgroup, "face-smiling")

            let flagWales = Character(exactly: "1F3F4 E0067 E0062 E0077 E006C E0073 E007F")
            XCTAssertEqual(dictionary[flagWales]?.character, "🏴󠁧󠁢󠁷󠁬󠁳󠁿")
            XCTAssertEqual(dictionary[flagWales]?.cldrOrder, emojiCountsListedInEmojiTest - 1) // the order starts from 0.

            XCTAssertEqual(dictionary[flagWales]?.group, "Flags")
            XCTAssertEqual(dictionary[flagWales]?.subgroup, "subdivision-flag")

        }

        try XCTContext.runActivity(named: "Test: An emoji that doesn't have any variations") { _ in

            // Assert For Variation Base
            let kissMarkCharacter = Character(exactly: "1F48B")
            let kissMarkEmoji = try XCTUnwrap(dictionary[kissMarkCharacter])
            XCTAssertEqual(kissMarkEmoji.character, "💋")

            // Assert for Qualified Variations
            XCTAssertNil(kissMarkEmoji.fullyQualifiedVersion)
            XCTAssertTrue(kissMarkEmoji.minimallyQualifiedOrUnqualifiedVersions.isEmpty)

            // Assert For Modifier Sequence Variations
            XCTAssertNil(kissMarkEmoji.genericSkinToneEmoji)
            XCTAssertTrue(kissMarkEmoji.orderedSkinToneEmojis.isEmpty)
        }

        try XCTContext.runActivity(named: "Test: An emoji that has modifier sequence's variation, but no qualified variations") { _ in

            // Assert For Variation Base
            let victoryHandCharacter = Character(exactly: "1F90F")
            let victoryHandEmoji = try XCTUnwrap(dictionary[victoryHandCharacter])
            XCTAssertEqual(victoryHandEmoji.character, "🤏")

            // Assert for Qualified Variations
            XCTAssertNil(victoryHandEmoji.fullyQualifiedVersion)
            XCTAssertTrue(victoryHandEmoji.minimallyQualifiedOrUnqualifiedVersions.isEmpty)

            // Assert For Modifier Sequence Variations
            let expectedSkintoneVariations = [
                Character(exactly: "1F90F 1F3FB"), // 🤏🏻
                Character(exactly: "1F90F 1F3FC"), // 🤏🏼
                Character(exactly: "1F90F 1F3FD"), // 🤏🏽
                Character(exactly: "1F90F 1F3FE"), // 🤏🏾
                Character(exactly: "1F90F 1F3FF")  // 🤏🏿
            ]

            XCTAssertNil(victoryHandEmoji.genericSkinToneEmoji)
            XCTAssertEqual(victoryHandEmoji.orderedSkinToneEmojis.count, 5)

            for (index, skintonedEmoji) in victoryHandEmoji.orderedSkinToneEmojis.enumerated() {
                XCTAssertEqual(skintonedEmoji.character, expectedSkintoneVariations[index])
                XCTAssertNil(skintonedEmoji.fullyQualifiedVersion)
                XCTAssertTrue(skintonedEmoji.minimallyQualifiedOrUnqualifiedVersions.isEmpty)
                XCTAssertEqual(skintonedEmoji.genericSkinToneEmoji, victoryHandEmoji)
                XCTAssertTrue(skintonedEmoji.orderedSkinToneEmojis.isEmpty)
            }

        }

        try XCTContext.runActivity(named: "Test: An emoji that has qualified, but no variationsmodifier sequence's variations") { _ in

            // Assert For Variation Base
            let passengerShipCharacter = Character(exactly: "1F6F3 FE0F")
            let passengerShipEmoji = try XCTUnwrap(dictionary[passengerShipCharacter])
            XCTAssertEqual(passengerShipEmoji.character, "🛳️")

            // Assert for Qualified Variations
            XCTAssertNil(passengerShipEmoji.fullyQualifiedVersion)
            XCTAssertEqual(passengerShipEmoji.minimallyQualifiedOrUnqualifiedVersions.count, 1)

            let qualifiedVariation = passengerShipEmoji.minimallyQualifiedOrUnqualifiedVersions[0]
            XCTAssertEqual(qualifiedVariation.fullyQualifiedVersion, passengerShipEmoji)
            XCTAssertTrue(qualifiedVariation.minimallyQualifiedOrUnqualifiedVersions.isEmpty)
            XCTAssertNil(qualifiedVariation.genericSkinToneEmoji)
            XCTAssertTrue(qualifiedVariation.orderedSkinToneEmojis.isEmpty)

            // Assert For Modifier Sequence Variations
            XCTAssertNil(passengerShipEmoji.genericSkinToneEmoji)
            XCTAssertTrue(passengerShipEmoji.orderedSkinToneEmojis.isEmpty)
        }

        try XCTContext.runActivity(named: "Test: An emoji that has both modifier sequences's variations and qualified variations.") { _ in

            // Assert For Variation Base
            let manDetectiveCharacter = Character(exactly: "1F575 FE0F 200D 2642 FE0F")
            let manDetectiveEmoji = try XCTUnwrap(dictionary[manDetectiveCharacter])
            XCTAssertEqual(manDetectiveEmoji.character, Character(exactly: "1F575 FE0F 200D 2642 FE0F")) // 🕵️‍♂️

            // Assert for Qualified Variations
            XCTAssertNil(manDetectiveEmoji.fullyQualifiedVersion)
            XCTAssertEqual(manDetectiveEmoji.minimallyQualifiedOrUnqualifiedVersions.count, 3)

            let expectedQualifiedVariations = [
                Character(exactly: "1F575 200D 2642 FE0F"), // 🕵‍♂️
                Character(exactly: "1F575 FE0F 200D 2642"), // 🕵️‍♂
                Character(exactly: "1F575 200D 2642")       // 🕵‍♂
            ]

            for (index, qualifiedVariation) in manDetectiveEmoji.minimallyQualifiedOrUnqualifiedVersions.enumerated() {
                XCTAssertEqual(qualifiedVariation.character, expectedQualifiedVariations[index])
                XCTAssertEqual(qualifiedVariation.fullyQualifiedVersion, manDetectiveEmoji)
                XCTAssertTrue(qualifiedVariation.minimallyQualifiedOrUnqualifiedVersions.isEmpty)
                XCTAssertNil(qualifiedVariation.genericSkinToneEmoji)
                XCTAssertTrue(qualifiedVariation.orderedSkinToneEmojis.isEmpty)
            }

            // Assert For Modifier Sequence Variations
            XCTAssertNil(manDetectiveEmoji.genericSkinToneEmoji)
            XCTAssertEqual(manDetectiveEmoji.orderedSkinToneEmojis.count, 5)

            let expectedSkintoneVariationssWithItsQualifiedVariation: [(Character, Character)] = [
                (Character(exactly: "1F575 1F3FB 200D 2642 FE0F"), Character(exactly: "1F575 1F3FB 200D 2642")), // 🕵🏻‍♂️, 🕵🏻‍♂
                (Character(exactly: "1F575 1F3FC 200D 2642 FE0F"), Character(exactly: "1F575 1F3FC 200D 2642")), // 🕵🏼‍♂️, 🕵🏼‍♂
                (Character(exactly: "1F575 1F3FD 200D 2642 FE0F"), Character(exactly: "1F575 1F3FD 200D 2642")), // 🕵🏽‍♂, 🕵🏽‍♂
                (Character(exactly: "1F575 1F3FE 200D 2642 FE0F"), Character(exactly: "1F575 1F3FE 200D 2642")), // 🕵🏾‍♂️, 🕵🏽‍♂
                (Character(exactly: "1F575 1F3FF 200D 2642 FE0F"), Character(exactly: "1F575 1F3FF 200D 2642")), // 🕵🏾‍♂️, 🕵🏽‍♂
            ]

            for (index, skintoneVariation) in manDetectiveEmoji.orderedSkinToneEmojis.enumerated() {
                XCTAssertEqual(skintoneVariation.character, expectedSkintoneVariationssWithItsQualifiedVariation[index].0)
                XCTAssertEqual(skintoneVariation.genericSkinToneEmoji, manDetectiveEmoji)
                XCTAssertTrue(skintoneVariation.orderedSkinToneEmojis.isEmpty)
                XCTAssertNil(skintoneVariation.fullyQualifiedVersion)

                XCTAssertEqual(skintoneVariation.minimallyQualifiedOrUnqualifiedVersions.count, 1)
                let qualifiedVariation = skintoneVariation.minimallyQualifiedOrUnqualifiedVersions[0]
                XCTAssertEqual(qualifiedVariation.character, expectedSkintoneVariationssWithItsQualifiedVariation[index].1)
                XCTAssertEqual(qualifiedVariation.fullyQualifiedVersion, skintoneVariation)
                XCTAssertTrue(qualifiedVariation.minimallyQualifiedOrUnqualifiedVersions.isEmpty)
                XCTAssertNil(qualifiedVariation.genericSkinToneEmoji)
                XCTAssertTrue(qualifiedVariation.orderedSkinToneEmojis.isEmpty)

            }

        }


    }

    func testPerformanceLoad() throws {

        let loader = EmojiLoader()

        // loader.load() should be finished less than 0.1sec.
        self.measure {
            loader.load()
        }

    }

    // MARK: - Testing EmojiLoader.Row

    func testInitCommentRow() {

        let line = "# This is test comment"
        let row = EmojiLoader.Row(line)
        XCTAssertEqual(row, .comment)

    }

    func testInitUnformatedRowFailOver() {

        let line = "こんにちわ！"
        let row = EmojiLoader.Row(line)
        XCTAssertEqual(row, .comment)

    }

    func testInitGroupHeaderRow() {

        let line = "# group: Smileys & Emotion"
        let row = EmojiLoader.Row(line)
        XCTAssertEqual(row, .groupHeader(groupName: "Smileys & Emotion"))

    }

    func testInitGroupHeaderRowFailOver() {

        let line = "# group:" // Doesn't have group name
        let row = EmojiLoader.Row(line)
        XCTAssertEqual(row, .comment)
        
    }

    func testInitSubgroupHeaderRow() {

        let line = "# subgroup: face-smiling"
        let row = EmojiLoader.Row(line)
        XCTAssertEqual(row, .subgroupHeader(suggroupName: "face-smiling"))
    }

    func testInitSubgroupHeaderFailOver() {

        let line = "# subgroup:"
        let row = EmojiLoader.Row(line)
        XCTAssertEqual(row, .comment)
    }

    // MARK: - Testing EmojiLoader.Data

    func testInitDataWhenFullyQualified() throws {

        let dataRowString = """
        1F93E 200D 2642 FE0F                                   ; fully-qualified     # 🤾‍♂️ E4.0 man playing handball
        """

        let data = try XCTUnwrap(EmojiLoader.Data(dataRowString: dataRowString))

        XCTAssertEqual(data.unicodeScalars.map({ $0.value }), [
            UInt32("1F93E", radix: 16)!,
            UInt32("200D", radix: 16)!,
            UInt32("2642", radix: 16)!,
            UInt32("FE0F", radix: 16)!
        ])

        XCTAssertEqual(data.status, .fullyQualified)

    }

    func testInitDataWhenMinimallyQualified() throws {

        let dataRowString = """
        26F9 1F3FF 200D 2642                                   ; minimally-qualified # ⛹🏿‍♂ E4.0 man bouncing ball: dark skin tone
        """

        let data = try XCTUnwrap(EmojiLoader.Data(dataRowString: dataRowString))

        XCTAssertEqual(data.unicodeScalars.map({ $0.value }), [
            UInt32("26F9", radix: 16)!,
            UInt32("1F3FF", radix: 16)!,
            UInt32("200D", radix: 16)!,
            UInt32("2642", radix: 16)!
        ])

        XCTAssertEqual(data.status, .minimallyQualified)

    }

    func testInitDataWhenUnqualified() throws {

        let dataRowString = """
        1F575                                                  ; unqualified         # 🕵 E0.7 detective
        """

        let data = try XCTUnwrap(EmojiLoader.Data(dataRowString: dataRowString))

        XCTAssertEqual(data.unicodeScalars.map({ $0.value }), [
            UInt32("1F575", radix: 16)!,
        ])

        XCTAssertEqual(data.status, .unqualified)

    }

    func testInitDataWhenComponent() throws {

        let dataRowString = """
        1F3FB                                                  ; component           # 🏻 E1.0 light skin tone
        """

        let data = try XCTUnwrap(EmojiLoader.Data(dataRowString: dataRowString))

        XCTAssertEqual(data.unicodeScalars.map({ $0.value }), [
            UInt32("1F3FB", radix: 16)!,
        ])

        XCTAssertEqual(data.status, .component)

    }

    func testInitDataWhenCommentNotFound() throws {

        let dataRowString = """
        1F469 200D 2764 FE0F 200D 1F48B 200D 1F469             ; fully-qualified
        """

        let data = try XCTUnwrap(EmojiLoader.Data(dataRowString: dataRowString))

        XCTAssertEqual(data.unicodeScalars, ["\u{1F469}", "\u{200D}", "\u{2764}", "\u{FE0F}", "\u{200D}", "\u{1F48B}", "\u{200D}", "\u{1F469}"])

        XCTAssertEqual(data.status, .fullyQualified)

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
