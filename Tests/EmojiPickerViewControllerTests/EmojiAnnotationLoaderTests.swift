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

import XCTest
@testable import EmojiPickerViewController

@MainActor class EmojiAnnotationLoaderTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testResourceURL() throws {

        let loader = EmojiAnnotationLoader(emojiDictionary: [:], emojiLocale: EmojiLocale(localeIdentifier: "zh-Hant_HK")!)
        XCTAssertEqual(loader.resourceURLs.map(\.lastPathComponent), ["zh_Hant.xml", "zh_Hant_HK.xml"], "Failed to replace the hyphen separated language code with underscore.")

    }

    func testLoadAnnotations() throws {

        let emojiDictionary: [Emoji.ID:Emoji] = [
            "😀": Emoji("😀"),
            "💏": Emoji("💏")
        ]

        let loader = EmojiAnnotationLoader(emojiDictionary: emojiDictionary, emojiLocale: EmojiLocale(localeIdentifier: "ja")!)
        loader.load()
        XCTAssertEqual(emojiDictionary["😀"]?.annotation, "スマイル | にっこり | にっこり笑う | 笑う | 笑顔 | 顔", "Failed to load `ja` annotations.")
        XCTAssertEqual(emojiDictionary["😀"]?.textToSpeech, "にっこり笑う", "Failed to load `ja` textToSpeech.")
        XCTAssertEqual(emojiDictionary["💏"]?.annotation, "2人でキス | カップル | キス | ちゅっ | ハート", "Failed to load `ja` annotations.")
        XCTAssertEqual(emojiDictionary["💏"]?.textToSpeech, "2人でキス", "Failed to load `ja` textToSpeech.")

    }

    func testNotLoadAnnotationsDerived() throws {

        let emojiDictionary: [Emoji.ID:Emoji] = [
            "👶🏾": Emoji("👶🏾")
        ]

        let loader = EmojiAnnotationLoader(emojiDictionary: emojiDictionary, emojiLocale:EmojiLocale(localeIdentifier: "ja")!)
        loader.load()

        XCTAssertEqual(emojiDictionary["👶🏾"]?.annotation, "")
        XCTAssertEqual(emojiDictionary["👶🏾"]?.textToSpeech, "")

    }

}
