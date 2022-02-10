//
//  EmojiLocaleTests.swift
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

class EmojiLocaleTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInit() throws {

        let resourceBaseURL = Bundle.module.resourceURL!

        let notexistValidFormLanguageCode = "zz"
        let notexistValidFormScriptCode = "Abcd"
        let notexistValidFormRegionCode = "ABC"

        XCTContext.runActivity(named: "language-script_region") { _ in

            XCTContext.runActivity(named: "exist-exist_exist") { _ in
                let locale = EmojiLocale(localeIdentifier: "sr-Cyrl_BA")
                XCTAssertNotNil(locale)
                XCTAssertEqual(locale?.localeIdentifier, "sr-Cyrl_BA")
                XCTAssertEqual(locale?.annotationFileURLs, [resourceBaseURL.appendingPathComponent("sr_Cyrl.xml"), resourceBaseURL.appendingPathComponent("sr_Cyrl_BA.xml")])
                XCTAssertEqual(locale?.annotationDerivedFileURLs, [resourceBaseURL.appendingPathComponent("sr_Cyrl_derived.xml"), resourceBaseURL.appendingPathComponent("sr_Cyrl_BA_derived.xml")])
            }

            XCTContext.runActivity(named: "exist-exist_notexist") { _ in
                let locale = EmojiLocale(localeIdentifier: "sr-Cyrl_\(notexistValidFormRegionCode)")
                XCTAssertNotNil(locale)
                XCTAssertEqual(locale?.localeIdentifier, "sr-Cyrl_\(notexistValidFormRegionCode)")
                XCTAssertEqual(locale?.annotationFileURLs, [resourceBaseURL.appendingPathComponent("sr_Cyrl.xml")])
                XCTAssertEqual(locale?.annotationDerivedFileURLs, [resourceBaseURL.appendingPathComponent("sr_Cyrl_derived.xml")])
            }

            XCTContext.runActivity(named: "exist-notexist_exist") { _ in
                let locale = EmojiLocale(localeIdentifier: "sr-\(notexistValidFormScriptCode)_BA")
                XCTAssertNil(locale)
            }

            XCTContext.runActivity(named: "exist-notexist_notexist") { _ in
                let locale = EmojiLocale(localeIdentifier: "sr-\(notexistValidFormScriptCode)_\(notexistValidFormRegionCode)")
                XCTAssertNil(locale)
            }

            XCTContext.runActivity(named: "notexist-exist_exist") { _ in
                let locale = EmojiLocale(localeIdentifier: "\(notexistValidFormLanguageCode)-Cyrl_BA")
                XCTAssertNil(locale)
            }

            XCTContext.runActivity(named: "notexist-exist_notexist") { _ in
                let locale = EmojiLocale(localeIdentifier: "\(notexistValidFormLanguageCode)-Cyrl_\(notexistValidFormRegionCode)")
                XCTAssertNil(locale)
            }

            XCTContext.runActivity(named: "notexist-notexist_exist") { _ in
                let locale = EmojiLocale(localeIdentifier: "\(notexistValidFormLanguageCode)-\(notexistValidFormScriptCode)_BA")
                XCTAssertNil(locale)
            }

            XCTContext.runActivity(named: "notexist-notexist_notexist") { _ in
                let locale = EmojiLocale(localeIdentifier: "\(notexistValidFormLanguageCode)-\(notexistValidFormScriptCode)_\(notexistValidFormRegionCode)")
                XCTAssertNil(locale)
            }

        }

        XCTContext.runActivity(named: "language-script") { _ in

            XCTContext.runActivity(named: "exist-exist") { _ in
                let locale = EmojiLocale(localeIdentifier: "zh-Hant")
                XCTAssertNotNil(locale)
                XCTAssertEqual(locale?.localeIdentifier, "zh-Hant")
                XCTAssertEqual(locale?.annotationFileURLs, [resourceBaseURL.appendingPathComponent("zh_Hant.xml")])
                XCTAssertEqual(locale?.annotationDerivedFileURLs, [resourceBaseURL.appendingPathComponent("zh_Hant_derived.xml")])
            }

            XCTContext.runActivity(named: "exist-notexist") { _ in
                let locale = EmojiLocale(localeIdentifier: "zh-\(notexistValidFormScriptCode)")
                XCTAssertNil(locale)
            }

            XCTContext.runActivity(named: "notexist-exist") { _ in
                let locale = EmojiLocale(localeIdentifier: "\(notexistValidFormLanguageCode)-Hant")
                XCTAssertNil(locale)
            }

            XCTContext.runActivity(named: "notexist-notexist") { _ in
                let locale = EmojiLocale(localeIdentifier: "\(notexistValidFormLanguageCode)-\(notexistValidFormScriptCode)")
                XCTAssertNil(locale)
            }

        }

        XCTContext.runActivity(named: "language_region") { _ in

            XCTContext.runActivity(named: "exist_exist") { _ in
                let locale = EmojiLocale(localeIdentifier: "en_IN")
                XCTAssertNotNil(locale)
                XCTAssertEqual(locale?.localeIdentifier, "en_IN")
                XCTAssertEqual(locale?.annotationFileURLs, [resourceBaseURL.appendingPathComponent("en.xml"), resourceBaseURL.appendingPathComponent("en_IN.xml")])
                XCTAssertEqual(locale?.annotationDerivedFileURLs, [resourceBaseURL.appendingPathComponent("en_derived.xml"), resourceBaseURL.appendingPathComponent("en_IN_derived.xml")])
            }

            XCTContext.runActivity(named: "exist_notexist") { _ in
                let locale = EmojiLocale(localeIdentifier: "en_\(notexistValidFormRegionCode)")
                XCTAssertNotNil(locale)
                XCTAssertEqual(locale?.localeIdentifier, "en_\(notexistValidFormRegionCode)")
                XCTAssertEqual(locale?.annotationFileURLs, [resourceBaseURL.appendingPathComponent("en.xml")])
                XCTAssertEqual(locale?.annotationDerivedFileURLs, [resourceBaseURL.appendingPathComponent("en_derived.xml")])
            }

            XCTContext.runActivity(named: "notexist_exist") { _ in
                let locale = EmojiLocale(localeIdentifier: "\(notexistValidFormLanguageCode)_IN")
                XCTAssertNil(locale)
            }

            XCTContext.runActivity(named: "notexist_notexist") { _ in
                let locale = EmojiLocale(localeIdentifier: "\(notexistValidFormLanguageCode)_\(notexistValidFormRegionCode)")
                XCTAssertNil(locale)
            }

        }

        XCTContext.runActivity(named: "language") { _ in

            XCTContext.runActivity(named: "exist") { _ in
                let locale = EmojiLocale(localeIdentifier: "bg")
                XCTAssertNotNil(locale)
                XCTAssertEqual(locale?.localeIdentifier, "bg")
                XCTAssertEqual(locale?.annotationFileURLs, [resourceBaseURL.appendingPathComponent("bg.xml")])
                XCTAssertEqual(locale?.annotationDerivedFileURLs, [resourceBaseURL.appendingPathComponent("bg_derived.xml")])
            }

            XCTContext.runActivity(named: "notexist") { _ in
                let locale = EmojiLocale(localeIdentifier: notexistValidFormLanguageCode)
                XCTAssertNil(locale)
            }

        }

    }

    func testAvailableIdentifier() throws {

        for identifier in EmojiLocale.availableIdentifiers {
            XCTAssertNotNil(Bundle.module.url(forResource: identifier, withExtension: "xml"))
        }

    }

}
