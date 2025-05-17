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

import XCTest
@testable import EmojiPickerViewController

@MainActor class EmojiAnnotationDerivedLoaderTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testResourceURL() throws {

        let loader = EmojiAnnotationDerivedLoader(emojiDictionary: [:], emojiLocale: EmojiLocale(localeIdentifier: "zh-Hant-HK")!)
        XCTAssertEqual(loader.resourceURLs.map(\.lastPathComponent), ["zh_Hant_derived.xml", "zh_Hant_HK_derived.xml"], "Failed to replace the hyphen separated language code with underscore.")

    }

    func testLoadAnnotationsDerived() throws {

        let emojiDictionary: [Emoji.ID:Emoji] = [
            "👋🏾": Emoji("👋🏾"),
            "🇲🇽": Emoji("🇲🇽")
        ]

        let loader = EmojiAnnotationDerivedLoader(emojiDictionary: emojiDictionary, emojiLocale: EmojiLocale(localeIdentifier: "ja")!)
        loader.load()

        XCTAssertEqual(emojiDictionary["👋🏾"]?.annotation, "バイバイ | やや濃い肌色 | 手 | 手を振る", "Failed to load `ja` annotations.")
        XCTAssertEqual(emojiDictionary["👋🏾"]?.textToSpeech, "手を振る: やや濃い肌色", "Failed to load `ja` textToSpeech.")
        XCTAssertEqual(emojiDictionary["🇲🇽"]?.annotation, "旗", "Failed to load `ja` annotations.")
        XCTAssertEqual(emojiDictionary["🇲🇽"]?.textToSpeech, "旗: メキシコ", "Failed to load `ja` textToSpeech.")

    }

    func testNotLoadAnnotations() throws {

        let emojiDictionary: [Emoji.ID:Emoji] = [
            "😀": Emoji("😀")
        ]

        let loader = EmojiAnnotationDerivedLoader(emojiDictionary: emojiDictionary, emojiLocale: EmojiLocale(localeIdentifier: "ja")!)
        loader.load()

        XCTAssertEqual(emojiDictionary["😀"]?.annotation, "")
        XCTAssertEqual(emojiDictionary["😀"]?.textToSpeech, "")

    }

}
