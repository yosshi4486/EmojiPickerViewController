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

    var userDefaults: UserDefaults!

    @MainActor override func setUpWithError() throws {
        userDefaults = UserDefaults(suiteName: "test")!
    }

    @MainActor override func tearDownWithError() throws {
        userDefaults.removePersistentDomain(forName: "test")
    }

    func testLoad() throws {

        let container = EmojiContainer()

        // Precheck
        XCTAssertEqual(container.emojiLocale.localeIdentifier, "en")
        XCTAssertTrue(container.labeledEmojisForKeyboard.isEmpty)
        XCTAssertTrue(container.entireEmojiSet.isEmpty)

        // Execute
        container.emojiLocale = EmojiLocale(localeIdentifier: "ja")!
        container.load()

        // Postcheck
        XCTAssertEqual(container.entireEmojiSet.count, emojiCountsListedInEmojiTest)
        XCTAssertEqual(container.labeledEmojisForKeyboard.values.joined().count, emojiCountsForShowingInKeyboard)

        let flagWales = Character("\u{1F3F4}\u{E0067}\u{E0062}\u{E0077}\u{E006C}\u{E0073}\u{E007F}")
        XCTAssertEqual(container.entireEmojiSet[flagWales]?.character, "🏴󠁧󠁢󠁷󠁬󠁳󠁿")
        XCTAssertEqual(container.entireEmojiSet[flagWales]?.cldrOrder, emojiCountsListedInEmojiTest - 1) // the order starts from 0.
        XCTAssertEqual(container.entireEmojiSet[flagWales]?.group, "Flags")
        XCTAssertEqual(container.entireEmojiSet[flagWales]?.subgroup, "subdivision-flag")
        XCTAssertEqual(container.entireEmojiSet[flagWales]?.annotation, "旗")
        XCTAssertEqual(container.entireEmojiSet[flagWales]?.textToSpeech, "旗: ウェールズ")

        XCTAssertEqual(container.labeledEmojisForKeyboard[.flags]?.last?.character, "🏴󠁧󠁢󠁷󠁬󠁳󠁿")
        XCTAssertEqual(container.labeledEmojisForKeyboard[.flags]?.last?.cldrOrder, emojiCountsListedInEmojiTest - 1) // the order starts from 0.
        XCTAssertEqual(container.labeledEmojisForKeyboard[.flags]?.last?.group, "Flags")
        XCTAssertEqual(container.labeledEmojisForKeyboard[.flags]?.last?.subgroup, "subdivision-flag")
        XCTAssertEqual(container.labeledEmojisForKeyboard[.flags]?.last?.annotation, "旗")
        XCTAssertEqual(container.labeledEmojisForKeyboard[.flags]?.last?.textToSpeech, "旗: ウェールズ")

        // Test all fully-qualified emojis have annotation and tts.
        for (_, emojis) in container.labeledEmojisForKeyboard {
            for emoji in emojis {
                XCTAssertNotEqual(emoji.annotation, "")
                XCTAssertNotEqual(emoji.textToSpeech, "")
                XCTAssertTrue(emoji.orderedSkinToneEmojis.allSatisfy({ $0.annotation != "" && $0.textToSpeech != "" }))
            }
        }

    }

    func testLoadAnnotationsOnly() throws {

        // Preparation
        let container = EmojiContainer()
        container.emojiLocale = EmojiLocale(localeIdentifier: "ja")!
        container.load()

        // Precheck
        XCTAssertEqual(container.entireEmojiSet.count, emojiCountsListedInEmojiTest)
        XCTAssertEqual(container.labeledEmojisForKeyboard.values.joined().count, emojiCountsForShowingInKeyboard)

        XCTAssertEqual(container.labeledEmojisForKeyboard[.smileysPeople]?.first?.character, "😀")
        XCTAssertEqual(container.labeledEmojisForKeyboard[.smileysPeople]?.first?.cldrOrder, 0)
        XCTAssertEqual(container.labeledEmojisForKeyboard[.smileysPeople]?.first?.group, "Smileys & Emotion")
        XCTAssertEqual(container.labeledEmojisForKeyboard[.smileysPeople]?.first?.subgroup, "face-smiling")
        XCTAssertEqual(container.labeledEmojisForKeyboard[.smileysPeople]?.first?.annotation, "スマイル | にっこり | にっこり笑う | 笑う | 笑顔 | 顔")
        XCTAssertEqual(container.labeledEmojisForKeyboard[.smileysPeople]?.first?.textToSpeech, "にっこり笑う")

        XCTAssertEqual(container.labeledEmojisForKeyboard[.flags]?.last?.character, "🏴󠁧󠁢󠁷󠁬󠁳󠁿")
        XCTAssertEqual(container.labeledEmojisForKeyboard[.flags]?.last?.cldrOrder, emojiCountsListedInEmojiTest - 1) // the order starts from 0.
        XCTAssertEqual(container.labeledEmojisForKeyboard[.flags]?.last?.group, "Flags")
        XCTAssertEqual(container.labeledEmojisForKeyboard[.flags]?.last?.subgroup, "subdivision-flag")
        XCTAssertEqual(container.labeledEmojisForKeyboard[.flags]?.last?.annotation, "旗")
        XCTAssertEqual(container.labeledEmojisForKeyboard[.flags]?.last?.textToSpeech, "旗: ウェールズ")

        // Execute
        container.emojiLocale = EmojiLocale(localeIdentifier: "en")!
        container.loadAnnotations()

        // Postcheck
        XCTAssertEqual(container.labeledEmojisForKeyboard[.smileysPeople]?.first?.character, "😀")
        XCTAssertEqual(container.labeledEmojisForKeyboard[.smileysPeople]?.first?.cldrOrder, 0)
        XCTAssertEqual(container.labeledEmojisForKeyboard[.smileysPeople]?.first?.group, "Smileys & Emotion")
        XCTAssertEqual(container.labeledEmojisForKeyboard[.smileysPeople]?.first?.subgroup, "face-smiling")
        XCTAssertEqual(container.labeledEmojisForKeyboard[.smileysPeople]?.first?.annotation, "face | grin | grinning face")
        XCTAssertEqual(container.labeledEmojisForKeyboard[.smileysPeople]?.first?.textToSpeech, "grinning face")

        XCTAssertEqual(container.labeledEmojisForKeyboard[.flags]?.last?.character, "🏴󠁧󠁢󠁷󠁬󠁳󠁿")
        XCTAssertEqual(container.labeledEmojisForKeyboard[.flags]?.last?.cldrOrder, emojiCountsListedInEmojiTest - 1) // the order starts from 0.
        XCTAssertEqual(container.labeledEmojisForKeyboard[.flags]?.last?.group, "Flags")
        XCTAssertEqual(container.labeledEmojisForKeyboard[.flags]?.last?.subgroup, "subdivision-flag")
        XCTAssertEqual(container.labeledEmojisForKeyboard[.flags]?.last?.annotation, "flag")
        XCTAssertEqual(container.labeledEmojisForKeyboard[.flags]?.last?.textToSpeech, "flag: Wales")

    }

    func testSearchEmojisForKeyboard() throws {

        // Preparation
        let container = EmojiContainer()
        container.emojiLocale = EmojiLocale(localeIdentifier: "en")!
        container.load()

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
        container.emojiLocale = EmojiLocale(localeIdentifier: "en")!
        container.load()

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

    func testRecentlyUsed() throws {

        let container = EmojiContainer()
        container.userDefaults = userDefaults
        container.load()
        container.storageAmountForRecentlyUsedEmoji = 3

        XCTAssertEqual(container.recentlyUsedEmojis, [])
        container.saveRecentlyUsedEmoji(Emoji("👌"))
        XCTAssertEqual(container.recentlyUsedEmojis.map(\.character), ["👌"])
        container.saveRecentlyUsedEmoji(Emoji("😵‍💫"))
        XCTAssertEqual(container.recentlyUsedEmojis.map(\.character), ["👌", "😵‍💫"])
        container.saveRecentlyUsedEmoji(Emoji("🍇"))
        XCTAssertEqual(container.recentlyUsedEmojis.map(\.character), ["👌", "😵‍💫", "🍇"])
        container.saveRecentlyUsedEmoji(Emoji("🛫"))
        XCTAssertEqual(container.recentlyUsedEmojis.map(\.character), ["😵‍💫", "🍇", "🛫"])

    }

    func testRecentlyUsedWhenNotLoaded() throws {

        let container = EmojiContainer()
        container.userDefaults = userDefaults
        container.storageAmountForRecentlyUsedEmoji = 3

        XCTAssertEqual(container.recentlyUsedEmojis, [])
        container.saveRecentlyUsedEmoji(Emoji("👌"))
        XCTAssertEqual(container.recentlyUsedEmojis.map(\.character), [])
        container.saveRecentlyUsedEmoji(Emoji("😵‍💫"))
        XCTAssertEqual(container.recentlyUsedEmojis.map(\.character), [])
        container.saveRecentlyUsedEmoji(Emoji("🍇"))
        XCTAssertEqual(container.recentlyUsedEmojis.map(\.character), [])
        container.saveRecentlyUsedEmoji(Emoji("🛫"))
        XCTAssertEqual(container.recentlyUsedEmojis.map(\.character), [])
    }

    func testRecentlyUsedWhenDuplicatedEmojiIsGiven() throws {

        let container = EmojiContainer()
        container.userDefaults = userDefaults
        container.load()
        container.storageAmountForRecentlyUsedEmoji = 3

        XCTAssertEqual(container.recentlyUsedEmojis, [])
        container.saveRecentlyUsedEmoji(Emoji("📫"))
        container.saveRecentlyUsedEmoji(Emoji("🏀"))
        container.saveRecentlyUsedEmoji(Emoji("🈵"))
        XCTAssertEqual(container.recentlyUsedEmojis.map(\.character), ["📫", "🏀", "🈵"])

        container.saveRecentlyUsedEmoji(Emoji("📫"))
        XCTAssertEqual(container.recentlyUsedEmojis.map(\.character), ["🏀", "🈵", "📫"])
    }

    func testArraySearchPerformance() throws {

        let container = EmojiContainer()
        container.emojiLocale = EmojiLocale(localeIdentifier: "en")!
        container.load()

        measure {
            _ = container.searchEmojisForKeyboard(from: "cop")

        }

    }

    func testRegexSearchPerformance() throws {

        let container = EmojiContainer()
        container.emojiLocale = EmojiLocale(localeIdentifier: "en")!
        container.load()

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
                return container.entireEmojiSet[character]
            })
            let copsDerived: [Emoji] = matchesOfAnnotationDerived.compactMap({
                let character = Character((annotationDerivedString as NSString).substring(with: $0.range(at: 1)))
                return container.entireEmojiSet[character]
            })

            let marged = cops + copsDerived
            let _ = marged.compactMap({ $0.fullyQualifiedVersion == nil ? $0 : $0.fullyQualifiedVersion }).sorted(by: { $0.cldrOrder < $1.cldrOrder })

        }

    }


}
