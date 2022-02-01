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

class EmojiAnnotationLoaderTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testResourceURL() throws {

        let baseURL = Bundle.module.resourceURL

        XCTContext.runActivity(named: "File Exist") { _ in

            let loader = EmojiAnnotationLoader(emojiDictionary: [:], languageIdentifiers: [])
            XCTAssertEqual(loader.resourceURL(for: "zh-Hant-HK"), baseURL?.appendingPathComponent("zh_Hant_HK.xml"), "Failed to replace the hyphen separated language code with underscore.")

        }

        XCTContext.runActivity(named: "File Not Exist") { _ in

            let loader = EmojiAnnotationLoader(emojiDictionary: [:], languageIdentifiers: [])
            XCTAssertNil(loader.resourceURL(for: "a-b-c-d"), "Failed to guard unlisted language codes.")

        }

    }

    func testLoad() throws {

        let emojiDictionary: [Emoji.ID:Emoji] = [
            "😀": Emoji(character: "😀", recommendedOrder: 0, group: "", subgroup: ""),
            "💏": Emoji(character: "💏", recommendedOrder: 0, group: "", subgroup: "")
        ]

        let loader = EmojiAnnotationLoader(emojiDictionary: emojiDictionary, languageIdentifiers: ["ja"])
        XCTAssertNoThrow(try loader.load())

        XCTAssertEqual(emojiDictionary["😀"]?.annotation, "スマイル | にっこり | にっこり笑う | 笑う | 笑顔 | 顔", "Failed to load `ja` annotations.")
        XCTAssertEqual(emojiDictionary["😀"]?.textToSpeach, "にっこり笑う", "Failed to load `ja` textToSpeach.")
        XCTAssertEqual(emojiDictionary["💏"]?.annotation, "2人でキス | カップル | キス | ちゅっ | ハート", "Failed to load `ja` annotations.")
        XCTAssertEqual(emojiDictionary["💏"]?.textToSpeach, "2人でキス", "Failed to load `ja` textToSpeach.")

    }

    func testLoadFailed() throws {

        let loader = EmojiAnnotationLoader(emojiDictionary: [:], languageIdentifiers: ["a-b-c-d"])

        XCTAssertThrowsError(try loader.load()) { error in

            if case .annotationFileNotFound(let languageCodes) = (error as? EmojiAnnotationLoader.Error) {

                XCTAssertEqual(languageCodes, ["a-b-c-d"], "Failed to get the expected language identifier.")

            } else {

                XCTFail("Failed to match case of enum. expected: EmojiAnnotationLoader.Error.annotationFileNotFound, actual: \(String(describing: error))")

            }
        }

    }

    func testLoadFailOver() throws {

        let emojiDictionary: [Emoji.ID:Emoji] = [
            "😀": Emoji(character: "😀", recommendedOrder: 0, group: "", subgroup: ""),
            "💏": Emoji(character: "💏", recommendedOrder: 0, group: "", subgroup: "")
        ]

        let loader = EmojiAnnotationLoader(emojiDictionary: emojiDictionary, languageIdentifiers: ["zh_Hans_SG", "agq_CM", "ar_KW", "ru"])
        XCTAssertNoThrow(try loader.load())

        XCTAssertEqual(emojiDictionary["😀"]?.annotation, "лицо | радость | счастье | улыбка | широкая улыбка | широко улыбается", "Failed to failover to `ru` language. The other annotation is loaded.")
        XCTAssertEqual(emojiDictionary["😀"]?.textToSpeach, "широко улыбается", "Failed to failover to `ru` language. The other textToSpeach is loaded.")
        XCTAssertEqual(emojiDictionary["💏"]?.annotation, "любовь | пара | поцелуй | романтика | чувства", "Failed to failover to `ru` language. The other annotation is loaded.")
        XCTAssertEqual(emojiDictionary["💏"]?.textToSpeach, "поцелуй", "Failed to failover to `ru` language. The other textToSpeach is loaded.")


    }

    func testLoadFailOverFailed() throws {

        let emojiDictionary: [Emoji.ID:Emoji] = [
            "😀": Emoji(character: "😀", recommendedOrder: 0, group: "", subgroup: ""),
            "💏": Emoji(character: "💏", recommendedOrder: 0, group: "", subgroup: "")
        ]

        // No available annotation file under Resources/CLDR directory.
        let loader = EmojiAnnotationLoader(emojiDictionary: emojiDictionary, languageIdentifiers: ["zh_Hans_SG", "agq_CM", "ar_KW"])
        XCTAssertThrowsError(try loader.load()) { error in

            if case .annotationFileNotFound(let languageCodes) = (error as? EmojiAnnotationLoader.Error) {

                XCTAssertEqual(languageCodes, ["zh_Hans_SG", "agq_CM", "ar_KW"], "Failed to get the expected language identifiers.")

            } else {

                XCTFail("Failed to match case of enum. expected: EmojiAnnotationLoader.Error.annotationFileNotFound, actual: \(String(describing: error))")

            }
        }

    }

    func testHeadLanguageIsPrioritized() throws {

        let emojiDictionary: [Emoji.ID:Emoji] = [
            "😀": Emoji(character: "😀", recommendedOrder: 0, group: "", subgroup: ""),
            "💏": Emoji(character: "💏", recommendedOrder: 0, group: "", subgroup: "")
        ]

        let loader = EmojiAnnotationLoader(emojiDictionary: emojiDictionary, languageIdentifiers: ["en", "ja", "de"]) // All associated annotation files exist.

        XCTAssertNoThrow(try loader.load())

        XCTAssertEqual(emojiDictionary["😀"]?.annotation, "face | grin | grinning face", "Failed to prioritized head language(en). The other language is loaded.")
        XCTAssertEqual(emojiDictionary["😀"]?.textToSpeach, "grinning face", "Failed to prioritized head language(en). The other language is loaded.")
        XCTAssertEqual(emojiDictionary["💏"]?.annotation, "couple | kiss", "Failed to prioritized head language(en). The other language is loaded.")
        XCTAssertEqual(emojiDictionary["💏"]?.textToSpeach, "kiss", "Failed to prioritized head language(en). The other language is loaded.")

    }


}
