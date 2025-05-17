//
//  EmojiAnnotationLoaderTests.swift
//
//  EmojiPickerViewController
//  https://github.com/yosshi4486/EmojiPickerViewController
// 
//  Created by yosshi4486 on 2022/02/01.
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

@testable import EmojiPickerViewController
import Testing

@Suite
@MainActor class EmojiAnnotationLoaderTests {

    @Test
    func resourceURL() throws {

        let loader = EmojiAnnotationLoader(emojiDictionary: [:], emojiLocale: EmojiLocale(localeIdentifier: "zh-Hant_HK")!)
        #expect(loader.resourceURLs.map(\.lastPathComponent) == ["zh_Hant.xml", "zh_Hant_HK.xml"])

    }

    @Test
    func loadAnnotations() throws {

        let emojiDictionary: [Emoji.ID:Emoji] = [
            "😀": Emoji("😀"),
            "💏": Emoji("💏")
        ]

        let loader = EmojiAnnotationLoader(emojiDictionary: emojiDictionary, emojiLocale: EmojiLocale(localeIdentifier: "ja")!)
        loader.load()
        #expect(emojiDictionary["😀"]?.annotation == "スマイル | にっこり | にっこり笑う | 笑う | 笑顔 | 顔")
        #expect(emojiDictionary["😀"]?.textToSpeech == "にっこり笑う")
        #expect(emojiDictionary["💏"]?.annotation == "2人でキス | カップル | キス | ちゅっ | ハート")
        #expect(emojiDictionary["💏"]?.textToSpeech == "2人でキス")

    }

    @Test
    func notLoadAnnotationsDerived() throws {

        let emojiDictionary: [Emoji.ID:Emoji] = [
            "👶🏾": Emoji("👶🏾")
        ]

        let loader = EmojiAnnotationLoader(emojiDictionary: emojiDictionary, emojiLocale:EmojiLocale(localeIdentifier: "ja")!)
        loader.load()

        #expect(emojiDictionary["👶🏾"]?.annotation == "")
        #expect(emojiDictionary["👶🏾"]?.textToSpeech == "")

    }

}
