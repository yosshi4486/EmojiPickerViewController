//
//  EmojiAnnotationLocaleTests.swift
//
//  EmojiPickerViewController
//  https://github.com/yosshi4486/EmojiPickerViewController
// 
//  Created by yosshi4486 on 2022/02/06.
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

class EmojiAnnotationLocaleTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInit() throws {

        let resourceBaseURL = Bundle.module.resourceURL

        XCTContext.runActivity(named: "Full valid identifier: without option") { _ in
            let locale = EmojiAnnotationLocale(languageIdentifier: "sr-Cyrl-BA")
            XCTAssertNotNil(locale)
            XCTAssertEqual(locale?.languageIdentifier, "sr_Cyrl_BA")
            XCTAssertEqual(locale?.annotationFileURL, resourceBaseURL?.appendingPathComponent("sr_Cyrl_BA.xml"))
            XCTAssertEqual(locale?.annotationDerivedFileURL, resourceBaseURL?.appendingPathComponent("sr_Cyrl_BA_derived.xml"))
        }

        XCTContext.runActivity(named: "Full valid identifier: with option") { _ in
            let locale = EmojiAnnotationLocale(languageIdentifier: "sr-Cyrl-BA", options: .useLanguageCodeOnly)
            XCTAssertNotNil(locale)
            XCTAssertEqual(locale?.languageIdentifier, "sr")
            XCTAssertEqual(locale?.annotationFileURL, resourceBaseURL?.appendingPathComponent("sr.xml"))
            XCTAssertEqual(locale?.annotationDerivedFileURL, resourceBaseURL?.appendingPathComponent("sr_derived.xml"))
        }

        XCTContext.runActivity(named: "Identifier which has a correct language code and wrong script or region designator: without option") { _ in
            let locale = EmojiAnnotationLocale(languageIdentifier: "ja-US")
            XCTAssertNil(locale)
        }

        XCTContext.runActivity(named: "Identifier which has correct language code and wrong script or region designator: with option") { _ in
            let locale = EmojiAnnotationLocale(languageIdentifier: "ja-US", options: .useLanguageCodeOnly)
            XCTAssertNotNil(locale)
            XCTAssertEqual(locale?.languageIdentifier, "ja")
            XCTAssertEqual(locale?.annotationFileURL, resourceBaseURL?.appendingPathComponent("ja.xml"))
            XCTAssertEqual(locale?.annotationDerivedFileURL, resourceBaseURL?.appendingPathComponent("ja_derived.xml"))
        }

        XCTContext.runActivity(named: "Invalid identifier: without option") { _ in
            // It's just a random identifier. pppoe is PPP over Ethernet;
            let locale = EmojiAnnotationLocale(languageIdentifier: "pppoe-NE-HK")
            XCTAssertNil(locale)
        }

        XCTContext.runActivity(named: "Invalid identifier: with option") { _ in
            // It's just a random identifier. pppoe is PPP over Ethernet;
            let locale = EmojiAnnotationLocale(languageIdentifier: "pppoe-NE-HK", options: .useLanguageCodeOnly)
            XCTAssertNil(locale)
        }


    }

}
