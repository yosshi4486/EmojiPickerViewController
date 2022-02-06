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

@MainActor class EmojiContainerTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    class StubTextInputMode: UITextInputMode {
        var textLanguage: String?

        override var primaryLanguage: String? {
            return textLanguage
        }
    }

    func testLoad() throws {

        let container = EmojiContainer()

        // Precheck
        XCTAssertEqual(container.annotationResource.localeIdentifier, "en")
        XCTAssertTrue(container.orderedEmojisForKeyboard.isEmpty)
        XCTAssertTrue(container.emojiDictionary.isEmpty)

        // Execute
        container.annotationResource = EmojiAnnotationResource(localeIdentifier: "ja")!
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

        // Test all fully-qualified emojis have annotation and tts.
        for emoji in container.orderedEmojisForKeyboard {
            XCTAssertNotEqual(emoji.annotation, "")
            XCTAssertNotEqual(emoji.textToSpeach, "")
            XCTAssertTrue(emoji.orderedSkinToneEmojis.allSatisfy({ $0.annotation != "" && $0.textToSpeach != "" }))
        }

    }

    func testLoadAnnotationsOnly() throws {

        // Preparation
        let container = EmojiContainer()
        container.annotationResource = EmojiAnnotationResource(localeIdentifier: "ja")!
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
        container.annotationResource = EmojiAnnotationResource(localeIdentifier: "en")!
        try container.loadAnnotations()

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

    func testSearchEmojisForKeyboard() throws {

        // Preparation
        let container = EmojiContainer()
        container.annotationResource = EmojiAnnotationResource(localeIdentifier: "en")!
        try container.load()

        // Search "frog"
        let frogs = container.searchEmojisForKeyboard(from: "frog")
        XCTAssertEqual(frogs.count, 1)
        XCTAssertEqual(frogs.first?.character, "🐸")

        // Search "cop"
        let cop = container.searchEmojisForKeyboard(from: "cop")
        XCTAssertEqual(cop.count, 4)

        XCTAssertEqual(cop[0].character, "👮")
        XCTAssertEqual(cop[1].character, "👮‍♂️")
        XCTAssertEqual(cop[2].character, "👮‍♀️")
        XCTAssertEqual(cop[3].character, "©️")

    }

    func testSearchEmojisForKeyboardAsync() async throws {

        // Preparation
        let container = EmojiContainer()
        container.annotationResource = EmojiAnnotationResource(localeIdentifier: "en")!
        try container.load()

        // Search "frog"
        let frogs = await container.searchEmojisForKeyboard(from: "frog")
        XCTAssertEqual(frogs.count, 1)
        XCTAssertEqual(frogs.first?.character, "🐸")

        // Search "cop"
        let cop = await container.searchEmojisForKeyboard(from: "cop")
        XCTAssertEqual(cop.count, 4)

        XCTAssertEqual(cop[0].character, "👮")
        XCTAssertEqual(cop[1].character, "👮‍♂️")
        XCTAssertEqual(cop[2].character, "👮‍♀️")
        XCTAssertEqual(cop[3].character, "©️")

    }

    func testContainerUpdatesAnnotationsWhenReceivingNotifications() throws {

        // Preparation
        let container = EmojiContainer()
        container.annotationResource = EmojiAnnotationResource(localeIdentifier: "en")!
        container.automaticallyUpdatingAnnotationsFollowingCurrentInputModeChange = true
        try container.load()

        let grinningFace = try XCTUnwrap(container.orderedEmojisForKeyboard.first)

        XCTAssertEqual(grinningFace.character, "😀")
        XCTAssertEqual(grinningFace.cldrOrder, 0)
        XCTAssertEqual(grinningFace.group, "Smileys & Emotion")
        XCTAssertEqual(grinningFace.subgroup, "face-smiling")
        XCTAssertEqual(grinningFace.annotation, "face | grin | grinning face")
        XCTAssertEqual(grinningFace.textToSpeach, "grinning face")

        XCTContext.runActivity(named: "Post notification: ja") { _ in
            let textInputMode = StubTextInputMode()
            textInputMode.textLanguage = "ja"

            let notificationExpectation = XCTNSNotificationExpectation(name: EmojiContainer.currentAnnotationDidChangeNotification, object: nil, notificationCenter: .default)
            NotificationCenter.default.post(name: UITextInputMode.currentInputModeDidChangeNotification, object: textInputMode)
            
            wait(for: [notificationExpectation], timeout: 1.0)
            XCTAssertEqual(grinningFace.character, "😀")
            XCTAssertEqual(grinningFace.annotation, "スマイル | にっこり | にっこり笑う | 笑う | 笑顔 | 顔")
            XCTAssertEqual(grinningFace.textToSpeach, "にっこり笑う")
        }

        XCTContext.runActivity(named: "Post notification: de_CH") { _ in
            let textInputMode = StubTextInputMode()
            textInputMode.textLanguage = "de_CH"

            let notificationExpectation = XCTNSNotificationExpectation(name: EmojiContainer.currentAnnotationDidChangeNotification, object: nil, notificationCenter: .default)
            NotificationCenter.default.post(name: UITextInputMode.currentInputModeDidChangeNotification, object: textInputMode)
            wait(for: [notificationExpectation], timeout: 1.0)

            XCTAssertEqual(grinningFace.character, "😀")
            XCTAssertEqual(grinningFace.annotation, "Gesicht | grinsendes Gesicht | lol | lustig")
            XCTAssertEqual(grinningFace.textToSpeach, "grinsendes Gesicht")

        }

        XCTContext.runActivity(named: "Post notification: zh_Hant_HK") { _ in
            let textInputMode = StubTextInputMode()
            textInputMode.textLanguage = "zh-Hant_HK"

            let notificationExpectation = XCTNSNotificationExpectation(name: EmojiContainer.currentAnnotationDidChangeNotification, object: nil, notificationCenter: .default)
            NotificationCenter.default.post(name: UITextInputMode.currentInputModeDidChangeNotification, object: textInputMode)
            wait(for: [notificationExpectation], timeout: 1.0)

            XCTAssertEqual(grinningFace.character, "😀")
            XCTAssertEqual(grinningFace.annotation, "微笑 | 笑臉")
            XCTAssertEqual(grinningFace.textToSpeach, "笑臉")
        }

    }



    func testArraySearchPerformance() throws {

        let container = EmojiContainer()
        container.annotationResource = EmojiAnnotationResource(localeIdentifier: "en")!
        try container.load()

        measure {
            _ = container.searchEmojisForKeyboard(from: "cop")

        }

    }

    func testRegexSearchPerformance() throws {

        let container = EmojiContainer()
        container.annotationResource = EmojiAnnotationResource(localeIdentifier: "en")!
        try container.load()

        // Even if we adopt regex for searching emojis, we have to search two files, which the one is annotations and the other is annotationsDerived, moreover we have to care about status of emojis in the implementation.
        // We think that the time difference is not big, so we decided to use array search for providing search API.
        measure {

            let annotationString = try! String(contentsOf: Bundle.module.url(forResource: "en", withExtension: "xml")!, encoding: .utf8)
            let annotationDerivedString = try! String(contentsOf: Bundle.module.url(forResource: "en_derived", withExtension: "xml")!, encoding: .utf8)

            let patternForSearchingAnnotation = String(format: #"<annotation cp="(.)">.*?(%@).*?</annotation>"#, "cop")
            let regularExpression = try! NSRegularExpression(pattern: patternForSearchingAnnotation, options: [])
            let matchesOfAnnotation = regularExpression.matches(in: annotationString, options: [], range: NSRange(location: 0, length: annotationString.utf16.count))
            let matchesOfAnnotationDerived = regularExpression.matches(in: annotationDerivedString, options: [], range: NSRange(location: 0, length: annotationDerivedString.utf16.count))

            let cops: [Emoji] = matchesOfAnnotation.compactMap({
                let character = Character((annotationString as NSString).substring(with: $0.range(at: 1)))
                return container.emojiDictionary[character]
            })
            let copsDerived: [Emoji] = matchesOfAnnotationDerived.compactMap({
                let character = Character((annotationDerivedString as NSString).substring(with: $0.range(at: 1)))
                return container.emojiDictionary[character]
            })

            let marged = cops + copsDerived
            let _ = marged.compactMap({ $0.fullyQualifiedVersion == nil ? $0 : $0.fullyQualifiedVersion }).sorted(by: { $0.cldrOrder < $1.cldrOrder })

        }

    }


}
