//
//  EmojiAnnotationResourceTests.swift
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

class EmojiAnnotationResourceTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testInit() throws {

        let resourceBaseURL = Bundle.module.resourceURL!

        /*
         The rule of joiners:
         - use _(underscore) before regional designator.
         - use -(hyphen) befoer script designator.

         For instance, "sr-Cyrl_BA", "sr" is language designator, "Cyrl" is script designator, "BA" is regional designator. Cyrl is joined by "-" and "BA" is joined by "_". Please check apple's document archive for details.
         */

        XCTContext.runActivity(named: "language-script_region") { _ in

            XCTContext.runActivity(named: "valid-valid_valid") { _ in
                let locale = EmojiAnnotationResource(localeIdentifier: "sr-Cyrl_BA")
                XCTAssertNotNil(locale)
                XCTAssertEqual(locale?.localeIdentifier, "sr-Cyrl_BA")
                XCTAssertEqual(locale?.annotationFileURLs, [resourceBaseURL.appendingPathComponent("sr_Cyrl.xml"), resourceBaseURL.appendingPathComponent("sr_Cyrl_BA.xml")])
                XCTAssertEqual(locale?.annotationDerivedFileURLs, [resourceBaseURL.appendingPathComponent("sr_Cyrl_derived.xml"), resourceBaseURL.appendingPathComponent("sr_Cyrl_BA_derived.xml")])
            }

            XCTContext.runActivity(named: "valid-valid_invalid") { _ in
                let locale = EmojiAnnotationResource(localeIdentifier: "sr-Cyrl_INVALID")
                XCTAssertNotNil(locale)
                XCTAssertEqual(locale?.localeIdentifier, "sr-Cyrl_INVALID")
                XCTAssertEqual(locale?.annotationFileURLs, [resourceBaseURL.appendingPathComponent("sr_Cyrl.xml")])
                XCTAssertEqual(locale?.annotationDerivedFileURLs, [resourceBaseURL.appendingPathComponent("sr_Cyrl_derived.xml")])
            }

            XCTContext.runActivity(named: "valid-invalid_valid") { _ in
                let locale = EmojiAnnotationResource(localeIdentifier: "sr-INVALID_BA")
                XCTAssertNil(locale)
            }

            XCTContext.runActivity(named: "valid-invalid_invalid") { _ in
                let locale = EmojiAnnotationResource(localeIdentifier: "sr-INVALID_INVALID")
                XCTAssertNil(locale)
            }

            XCTContext.runActivity(named: "invalid-valid_valid") { _ in
                let locale = EmojiAnnotationResource(localeIdentifier: "INVALID-Cyrl_BA")
                XCTAssertNil(locale)
            }

            XCTContext.runActivity(named: "invalid-valid_invalid") { _ in
                let locale = EmojiAnnotationResource(localeIdentifier: "INVALID-Cyrl_INVALID")
                XCTAssertNil(locale)
            }

            XCTContext.runActivity(named: "invalid-invalid_valid") { _ in
                let locale = EmojiAnnotationResource(localeIdentifier: "INVALID-INVALID_BA")
                XCTAssertNil(locale)
            }

            XCTContext.runActivity(named: "invalid-invalid_invalid") { _ in
                let locale = EmojiAnnotationResource(localeIdentifier: "INVALID-INVALID_INVALID")
                XCTAssertNil(locale)
            }

        }

        XCTContext.runActivity(named: "language-script") { _ in

            XCTContext.runActivity(named: "valid-valid") { _ in
                let locale = EmojiAnnotationResource(localeIdentifier: "zh-Hant")
                XCTAssertNotNil(locale)
                XCTAssertEqual(locale?.localeIdentifier, "zh-Hant")
                XCTAssertEqual(locale?.annotationFileURLs, [resourceBaseURL.appendingPathComponent("zh_Hant.xml")])
                XCTAssertEqual(locale?.annotationDerivedFileURLs, [resourceBaseURL.appendingPathComponent("zh_Hant_derived.xml")])
            }

            XCTContext.runActivity(named: "valid-invalid") { _ in
                let locale = EmojiAnnotationResource(localeIdentifier: "zh-INVALID")
                XCTAssertNil(locale)
            }

            XCTContext.runActivity(named: "invalid-valid") { _ in
                let locale = EmojiAnnotationResource(localeIdentifier: "INVALID-Hant")
                XCTAssertNil(locale)
            }

            XCTContext.runActivity(named: "invalid-invalid") { _ in
                let locale = EmojiAnnotationResource(localeIdentifier: "INVALID-INVALID")
                XCTAssertNil(locale)
            }

        }

        XCTContext.runActivity(named: "language_region") { _ in

            XCTContext.runActivity(named: "valid_valid") { _ in
                let locale = EmojiAnnotationResource(localeIdentifier: "en_IN")
                XCTAssertNotNil(locale)
                XCTAssertEqual(locale?.localeIdentifier, "en_IN")
                XCTAssertEqual(locale?.annotationFileURLs, [resourceBaseURL.appendingPathComponent("en.xml"), resourceBaseURL.appendingPathComponent("en_IN.xml")])
                XCTAssertEqual(locale?.annotationDerivedFileURLs, [resourceBaseURL.appendingPathComponent("en_derived.xml"), resourceBaseURL.appendingPathComponent("en_IN_derived.xml")])
            }

            XCTContext.runActivity(named: "valid_invalid") { _ in
                let locale = EmojiAnnotationResource(localeIdentifier: "en_INVALID")
                XCTAssertNotNil(locale)
                XCTAssertEqual(locale?.localeIdentifier, "en_INVALID")
                XCTAssertEqual(locale?.annotationFileURLs, [resourceBaseURL.appendingPathComponent("en.xml")])
                XCTAssertEqual(locale?.annotationDerivedFileURLs, [resourceBaseURL.appendingPathComponent("en_derived.xml")])
            }

            XCTContext.runActivity(named: "invalid_valid") { _ in
                let locale = EmojiAnnotationResource(localeIdentifier: "INVALID_IN")
                XCTAssertNil(locale)
            }

            XCTContext.runActivity(named: "invalid_invalid") { _ in
                let locale = EmojiAnnotationResource(localeIdentifier: "INVALID_INVALID")
                XCTAssertNil(locale)
            }

        }

        XCTContext.runActivity(named: "language") { _ in

            XCTContext.runActivity(named: "valid") { _ in
                let locale = EmojiAnnotationResource(localeIdentifier: "bg")
                XCTAssertNotNil(locale)
                XCTAssertEqual(locale?.localeIdentifier, "bg")
                XCTAssertEqual(locale?.annotationFileURLs, [resourceBaseURL.appendingPathComponent("bg.xml")])
                XCTAssertEqual(locale?.annotationDerivedFileURLs, [resourceBaseURL.appendingPathComponent("bg_derived.xml")])
            }

            XCTContext.runActivity(named: "invalid") { _ in
                let locale = EmojiAnnotationResource(localeIdentifier: "INVALID")
                XCTAssertNil(locale)
            }

        }

    }

}
