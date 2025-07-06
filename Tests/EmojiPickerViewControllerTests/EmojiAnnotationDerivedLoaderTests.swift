//
//  EmojiAnnotationDerivedLoaderTests.swift
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
@testable import EmojiPickerViewController

@Suite
@MainActor struct EmojiAnnotationDerivedLoaderTests {

    @Test
    func resourceURL() throws {

        let loader = EmojiAnnotationDerivedLoader(emojiDictionary: [:], emojiLocale: EmojiLocale(localeIdentifier: "zh-Hant-HK")!)
        #expect(loader.resourceURLs.map(\.lastPathComponent) == ["zh_Hant_derived.xml", "zh_Hant_HK_derived.xml"], "Failed to replace the hyphen separated language code with underscore.")

    }

    @Test
    func loadAnnotationsDerived() throws {

        let emojiDictionary: [Emoji.ID:Emoji] = [
            "👋🏾": Emoji("👋🏾"),
            "🇲🇽": Emoji("🇲🇽")
        ]

        let loader = EmojiAnnotationDerivedLoader(emojiDictionary: emojiDictionary, emojiLocale: EmojiLocale(localeIdentifier: "ja")!)
        loader.load()

        #expect(emojiDictionary["👋🏾"]?.annotation == "あいさつ | さようなら | バイバイ | ハロー | またね | やや濃い肌色 | 手 | 手を振る", "Failed to load `ja` annotations.")
        #expect(emojiDictionary["👋🏾"]?.textToSpeech == "手を振る: やや濃い肌色", "Failed to load `ja` textToSpeech.")
        #expect(emojiDictionary["🇲🇽"]?.annotation == "旗", "Failed to load `ja` annotations.")
        #expect(emojiDictionary["🇲🇽"]?.textToSpeech == "旗: メキシコ", "Failed to load `ja` textToSpeech.")

    }

    @Test
    func notLoadAnnotations() throws {

        let emojiDictionary: [Emoji.ID:Emoji] = [
            "😀": Emoji("😀")
        ]

        let loader = EmojiAnnotationDerivedLoader(emojiDictionary: emojiDictionary, emojiLocale: EmojiLocale(localeIdentifier: "ja")!)
        loader.load()

        #expect(emojiDictionary["😀"]?.annotation == "")
        #expect(emojiDictionary["😀"]?.textToSpeech == "")

    }

}
