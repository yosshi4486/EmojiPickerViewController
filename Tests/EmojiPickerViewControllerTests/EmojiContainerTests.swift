//
//  EmojiContainerTests.swift
//
//  EmojiPickerViewController
//  https://github.com/yosshi4486/EmojiPickerViewController
// 
//  Created by yosshi4486 on 2022/02/02.
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

class EmojiContainerTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLoad() throws {

        let container = EmojiContainer()

        // Precheck
        XCTAssertTrue(container.preferredLanguageIdentifiers.isEmpty)
        XCTAssertTrue(container.languageIdentifiers.isEmpty)
        XCTAssertTrue(container.orderedEmojisForKeyboard.isEmpty)
        XCTAssertTrue(container.emojiDictionary.isEmpty)

        // Execute
        container.preferredLanguageIdentifiers = ["ja"]
        try container.load()

        // Postcheck
        XCTAssertEqual(container.emojiDictionary.count, emojiCountsListedInEmojiTest)
        XCTAssertEqual(container.orderedEmojisForKeyboard.count, emojiCountsForShowingInKeyboard)

        XCTAssertEqual(container.orderedEmojisForKeyboard.last?.character, "🏴󠁧󠁢󠁷󠁬󠁳󠁿")
        XCTAssertEqual(container.orderedEmojisForKeyboard.last?.cldrOrder, emojiCountsListedInEmojiTest - 1) // the order starts from 0.
        XCTAssertEqual(container.orderedEmojisForKeyboard.last?.group, "Flags")
        XCTAssertEqual(container.orderedEmojisForKeyboard.last?.subgroup, "subdivision-flag")
        XCTAssertEqual(container.orderedEmojisForKeyboard.last?.annotation, "旗")
        XCTAssertEqual(container.orderedEmojisForKeyboard.last?.textToSpeach, "旗: ウェールズ")

        let flagWales = Character("\u{1F3F4}\u{E0067}\u{E0062}\u{E0077}\u{E006C}\u{E0073}\u{E007F}")
        XCTAssertEqual(container.emojiDictionary[flagWales]?.character, "🏴󠁧󠁢󠁷󠁬󠁳󠁿")
        XCTAssertEqual(container.emojiDictionary[flagWales]?.cldrOrder, emojiCountsListedInEmojiTest - 1) // the order starts from 0.
        XCTAssertEqual(container.emojiDictionary[flagWales]?.group, "Flags")
        XCTAssertEqual(container.emojiDictionary[flagWales]?.subgroup, "subdivision-flag")
        XCTAssertEqual(container.emojiDictionary[flagWales]?.annotation, "旗")
        XCTAssertEqual(container.emojiDictionary[flagWales]?.textToSpeach, "旗: ウェールズ")
    }

    func testLoadAnnotationsOnly() throws {

        // Preparation
        let container = EmojiContainer()
        container.preferredLanguageIdentifiers = ["ja"]
        try container.load()

        // Precheck
        XCTAssertEqual(container.emojiDictionary.count, emojiCountsListedInEmojiTest)
        XCTAssertEqual(container.orderedEmojisForKeyboard.count, emojiCountsForShowingInKeyboard)

        XCTAssertEqual(container.orderedEmojisForKeyboard.first?.character, "😀")
        XCTAssertEqual(container.orderedEmojisForKeyboard.first?.cldrOrder, 0)
        XCTAssertEqual(container.orderedEmojisForKeyboard.first?.group, "Smileys & Emotion")
        XCTAssertEqual(container.orderedEmojisForKeyboard.first?.subgroup, "face-smiling")
        XCTAssertEqual(container.orderedEmojisForKeyboard.first?.annotation, "スマイル | にっこり | にっこり笑う | 笑う | 笑顔 | 顔")
        XCTAssertEqual(container.orderedEmojisForKeyboard.first?.textToSpeach, "にっこり笑う")

        XCTAssertEqual(container.orderedEmojisForKeyboard.last?.character, "🏴󠁧󠁢󠁷󠁬󠁳󠁿")
        XCTAssertEqual(container.orderedEmojisForKeyboard.last?.cldrOrder, emojiCountsListedInEmojiTest - 1) // the order starts from 0.
        XCTAssertEqual(container.orderedEmojisForKeyboard.last?.group, "Flags")
        XCTAssertEqual(container.orderedEmojisForKeyboard.last?.subgroup, "subdivision-flag")
        XCTAssertEqual(container.orderedEmojisForKeyboard.last?.annotation, "旗")
        XCTAssertEqual(container.orderedEmojisForKeyboard.last?.textToSpeach, "旗: ウェールズ")

        // Execute
        container.preferredLanguageIdentifiers = ["en"]
        try container.load()

        // Postcheck
        XCTAssertEqual(container.orderedEmojisForKeyboard.first?.character, "😀")
        XCTAssertEqual(container.orderedEmojisForKeyboard.first?.cldrOrder, 0)
        XCTAssertEqual(container.orderedEmojisForKeyboard.first?.group, "Smileys & Emotion")
        XCTAssertEqual(container.orderedEmojisForKeyboard.first?.subgroup, "face-smiling")
        XCTAssertEqual(container.orderedEmojisForKeyboard.first?.annotation, "face | grin | grinning face")
        XCTAssertEqual(container.orderedEmojisForKeyboard.first?.textToSpeach, "grinning face")

        XCTAssertEqual(container.orderedEmojisForKeyboard.last?.character, "🏴󠁧󠁢󠁷󠁬󠁳󠁿")
        XCTAssertEqual(container.orderedEmojisForKeyboard.last?.cldrOrder, emojiCountsListedInEmojiTest - 1) // the order starts from 0.
        XCTAssertEqual(container.orderedEmojisForKeyboard.last?.group, "Flags")
        XCTAssertEqual(container.orderedEmojisForKeyboard.last?.subgroup, "subdivision-flag")
        XCTAssertEqual(container.orderedEmojisForKeyboard.last?.annotation, "flag")
        XCTAssertEqual(container.orderedEmojisForKeyboard.last?.textToSpeach, "flag: Wales")

    }

}
