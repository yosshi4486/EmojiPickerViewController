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

import Testing
import Foundation
@testable import EmojiPickerViewController

@Suite
@MainActor class EmojiContainerTests {

    nonisolated(unsafe) var userDefaults: UserDefaults!
    
    init() {
        userDefaults = UserDefaults(suiteName: "test")!
    }

    deinit {
        userDefaults.removePersistentDomain(forName: "test")
    }

    @Test
    func load() throws {

        let container = EmojiContainer()

        // Precheck
        #expect(container.emojiLocale.localeIdentifier == "en")
        #expect(container.labeledEmojisForKeyboard.isEmpty)
        #expect(container.entireEmojiSet.isEmpty)

        // Execute
        container.emojiLocale = EmojiLocale(localeIdentifier: "ja")!
        container.load()

        // Postcheck
        #expect(container.entireEmojiSet.count == emojiCountsListedInEmojiTest)
        #expect(container.labeledEmojisForKeyboard.values.joined().count == emojiCountsForShowingInKeyboard)

        let flagWales = Character("\u{1F3F4}\u{E0067}\u{E0062}\u{E0077}\u{E006C}\u{E0073}\u{E007F}")
        #expect(container.entireEmojiSet[flagWales]?.character == "🏴󠁧󠁢󠁷󠁬󠁳󠁿")
        #expect(container.entireEmojiSet[flagWales]?.cldrOrder == emojiCountsListedInEmojiTest - 1) // the order starts from 0.
        #expect(container.entireEmojiSet[flagWales]?.group == "Flags")
        #expect(container.entireEmojiSet[flagWales]?.subgroup == "subdivision-flag")
        #expect(container.entireEmojiSet[flagWales]?.annotation == "旗")
        #expect(container.entireEmojiSet[flagWales]?.textToSpeech == "旗: ウェールズ")

        #expect(container.labeledEmojisForKeyboard[.flags]?.last?.character == "🏴󠁧󠁢󠁷󠁬󠁳󠁿")
        #expect(container.labeledEmojisForKeyboard[.flags]?.last?.cldrOrder == emojiCountsListedInEmojiTest - 1) // the order starts from 0.
        #expect(container.labeledEmojisForKeyboard[.flags]?.last?.group == "Flags")
        #expect(container.labeledEmojisForKeyboard[.flags]?.last?.subgroup == "subdivision-flag")
        #expect(container.labeledEmojisForKeyboard[.flags]?.last?.annotation == "旗")
        #expect(container.labeledEmojisForKeyboard[.flags]?.last?.textToSpeech == "旗: ウェールズ")

        // Test all fully-qualified emojis have annotation and tts.
        for (_, emojis) in container.labeledEmojisForKeyboard {
            for emoji in emojis {
                #expect(emoji.annotation != "")
                #expect(emoji.textToSpeech != "")
                #expect(emoji.orderedSkinToneEmojis.allSatisfy({ $0.annotation != "" && $0.textToSpeech != "" }))
            }
        }

    }

    @Test
    func loadAnnotationsOnly() throws {

        // Preparation
        let container = EmojiContainer()
        container.emojiLocale = EmojiLocale(localeIdentifier: "ja")!
        container.load()

        // Precheck
        #expect(container.entireEmojiSet.count == emojiCountsListedInEmojiTest)
        #expect(container.labeledEmojisForKeyboard.values.joined().count == emojiCountsForShowingInKeyboard)

        #expect(container.labeledEmojisForKeyboard[.smileysPeople]?.first?.character == "😀")
        #expect(container.labeledEmojisForKeyboard[.smileysPeople]?.first?.cldrOrder == 0)
        #expect(container.labeledEmojisForKeyboard[.smileysPeople]?.first?.group == "Smileys & Emotion")
        #expect(container.labeledEmojisForKeyboard[.smileysPeople]?.first?.subgroup == "face-smiling")
        #expect(container.labeledEmojisForKeyboard[.smileysPeople]?.first?.annotation == "スマイル | にっこり | にっこり笑う | 笑う | 笑顔 | 顔")
        #expect(container.labeledEmojisForKeyboard[.smileysPeople]?.first?.textToSpeech == "にっこり笑う")

        #expect(container.labeledEmojisForKeyboard[.flags]?.last?.character == "🏴󠁧󠁢󠁷󠁬󠁳󠁿")
        #expect(container.labeledEmojisForKeyboard[.flags]?.last?.cldrOrder == emojiCountsListedInEmojiTest - 1) // the order starts from 0.
        #expect(container.labeledEmojisForKeyboard[.flags]?.last?.group == "Flags")
        #expect(container.labeledEmojisForKeyboard[.flags]?.last?.subgroup == "subdivision-flag")
        #expect(container.labeledEmojisForKeyboard[.flags]?.last?.annotation == "旗")
        #expect(container.labeledEmojisForKeyboard[.flags]?.last?.textToSpeech == "旗: ウェールズ")

        // Execute
        container.emojiLocale = EmojiLocale(localeIdentifier: "en")!
        container.loadAnnotations()

        // Postcheck
        #expect(container.labeledEmojisForKeyboard[.smileysPeople]?.first?.character == "😀")
        #expect(container.labeledEmojisForKeyboard[.smileysPeople]?.first?.cldrOrder == 0)
        #expect(container.labeledEmojisForKeyboard[.smileysPeople]?.first?.group == "Smileys & Emotion")
        #expect(container.labeledEmojisForKeyboard[.smileysPeople]?.first?.subgroup == "face-smiling")
        #expect(container.labeledEmojisForKeyboard[.smileysPeople]?.first?.annotation == "face | grin | grinning face")
        #expect(container.labeledEmojisForKeyboard[.smileysPeople]?.first?.textToSpeech == "grinning face")

        #expect(container.labeledEmojisForKeyboard[.flags]?.last?.character == "🏴󠁧󠁢󠁷󠁬󠁳󠁿")
        #expect(container.labeledEmojisForKeyboard[.flags]?.last?.cldrOrder == emojiCountsListedInEmojiTest - 1) // the order starts from 0.
        #expect(container.labeledEmojisForKeyboard[.flags]?.last?.group == "Flags")
        #expect(container.labeledEmojisForKeyboard[.flags]?.last?.subgroup == "subdivision-flag")
        #expect(container.labeledEmojisForKeyboard[.flags]?.last?.annotation == "flag")
        #expect(container.labeledEmojisForKeyboard[.flags]?.last?.textToSpeech == "flag: Wales")

    }

    @Test
    func searchEmojisForKeyboard() async throws {

        // Preparation
        let container = EmojiContainer()
        container.emojiLocale = EmojiLocale(localeIdentifier: "en")!
        container.load()

        // Search "frog"
        let frogs = await container.searchEmojisForKeyboard(from: "frog")
        #expect(frogs.count == 1)
        #expect(frogs.first?.character == "🐸")

        // Search "cop"
        let cop = await container.searchEmojisForKeyboard(from: "cop")
        #expect(cop.count == 4)

        #expect(cop[0].character == "👮")
        #expect(cop[1].character == "👮‍♂️")
        #expect(cop[2].character == "👮‍♀️")
        #expect(cop[3].character == "©️")

    }

    @Test
    func searchEmojisForKeyboardAsync() async throws {

        // Preparation
        let container = EmojiContainer()
        container.emojiLocale = EmojiLocale(localeIdentifier: "en")!
        container.load()

        // Search "frog"
        let frogs = await container.searchEmojisForKeyboard(from: "frog")
        #expect(frogs.count == 1)
        #expect(frogs.first?.character == "🐸")

        // Search "cop"
        let cop = await container.searchEmojisForKeyboard(from: "cop")
        #expect(cop.count == 4)

        #expect(cop[0].character == "👮")
        #expect(cop[1].character == "👮‍♂️")
        #expect(cop[2].character == "👮‍♀️")
        #expect(cop[3].character == "©️")

    }

    @Test
    func recentlyUsed() throws {

        let container = EmojiContainer()
        container.userDefaults = userDefaults
        container.load()
        container.storageAmountForRecentlyUsedEmoji = 3

        #expect(container.recentlyUsedEmojis == [])
        container.saveRecentlyUsedEmoji(Emoji("👌"))
        #expect(container.recentlyUsedEmojis.map(\.character) == ["👌"])
        container.saveRecentlyUsedEmoji(Emoji("😵‍💫"))
        #expect(container.recentlyUsedEmojis.map(\.character) == ["👌", "😵‍💫"])
        container.saveRecentlyUsedEmoji(Emoji("🍇"))
        #expect(container.recentlyUsedEmojis.map(\.character) == ["👌", "😵‍💫", "🍇"])
        container.saveRecentlyUsedEmoji(Emoji("🛫"))
        #expect(container.recentlyUsedEmojis.map(\.character) == ["😵‍💫", "🍇", "🛫"])

    }

    @Test
    func recentlyUsedWhenNotLoaded() throws {

        let container = EmojiContainer()
        container.userDefaults = userDefaults
        container.storageAmountForRecentlyUsedEmoji = 3

        #expect(container.recentlyUsedEmojis == [])
        container.saveRecentlyUsedEmoji(Emoji("👌"))
        #expect(container.recentlyUsedEmojis.map(\.character) == [])
        container.saveRecentlyUsedEmoji(Emoji("😵‍💫"))
        #expect(container.recentlyUsedEmojis.map(\.character) == [])
        container.saveRecentlyUsedEmoji(Emoji("🍇"))
        #expect(container.recentlyUsedEmojis.map(\.character) == [])
        container.saveRecentlyUsedEmoji(Emoji("🛫"))
        #expect(container.recentlyUsedEmojis.map(\.character) == [])
    }

    @Test
    func recentlyUsedWhenDuplicatedEmojiIsGiven() throws {

        let container = EmojiContainer()
        container.userDefaults = userDefaults
        container.load()
        container.storageAmountForRecentlyUsedEmoji = 3

        #expect(container.recentlyUsedEmojis == [])
        container.saveRecentlyUsedEmoji(Emoji("📫"))
        container.saveRecentlyUsedEmoji(Emoji("🏀"))
        container.saveRecentlyUsedEmoji(Emoji("🈵"))
        #expect(container.recentlyUsedEmojis.map(\.character) == ["📫", "🏀", "🈵"])

        container.saveRecentlyUsedEmoji(Emoji("📫"))
        #expect(container.recentlyUsedEmojis.map(\.character) == ["🏀", "🈵", "📫"])
    }


}

#if !os(Linux)
import XCTest

@MainActor
class EmojiContainerPerformanceTests : XCTestCase {
    
    func testArraySearchPerformance() async throws {

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
#endif
