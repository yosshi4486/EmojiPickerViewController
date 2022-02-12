//
//  StringExtensionTests.swift
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

class StringExtensionTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testIsISO639LanguageCodeForm() throws {

        // whitebox testing: MCC

        XCTContext.runActivity(named: "count:2, ascii, lowercase") { _ in
            XCTAssertTrue("ab".isISO639LanguageCodeForm)
        }

        XCTContext.runActivity(named: "count:2, ascii, not-lowercase") { _ in
            XCTAssertFalse("aB".isISO639LanguageCodeForm)
        }

        XCTContext.runActivity(named: "count:2, not-ascii, lowercase") { _ in
            XCTAssertFalse("éи".isISO639LanguageCodeForm)
        }

        XCTContext.runActivity(named: "count:2, not-ascii, not-lowercase") { _ in
            XCTAssertFalse("空腹".isISO639LanguageCodeForm)
        }

        XCTContext.runActivity(named: "count:4, ascii, lowercase") { _ in
            XCTAssertFalse("abzz".isISO639LanguageCodeForm)
        }

        XCTContext.runActivity(named: "count:4, ascii, not-lowercase") { _ in
            XCTAssertFalse("abZz".isISO639LanguageCodeForm)
        }

        XCTContext.runActivity(named: "count:4, not-ascii, lowercase") { _ in
            XCTAssertFalse("éиπé".isISO639LanguageCodeForm)
        }

        XCTContext.runActivity(named: "count:4, not-ascii, not-lowercase") { _ in
            XCTAssertFalse("空腹限界".isISO639LanguageCodeForm)
        }

        // additional

        XCTContext.runActivity(named: "count:3, ascii, lowercase") { _ in
            XCTAssertTrue("abc".isISO639LanguageCodeForm)
        }

    }

    func testIsISO3166RegionCodeForm() throws {

        // I'm writing very rough tests.

        XCTContext.runActivity(named: "count:1, ascii, upper") { _ in
            XCTAssertFalse("Z".isISO3166RegionCodeForm)
        }

        XCTContext.runActivity(named: "count:3, ascii, upper") { _ in
            XCTAssertTrue("ABB".isISO3166RegionCodeForm)
        }

        XCTContext.runActivity(named: "count:3, ascii, not-upper") { _ in
            XCTAssertFalse("AbB".isISO3166RegionCodeForm)
        }

        XCTContext.runActivity(named: "count:3, not-ascii, upper") { _ in
            XCTAssertFalse("ÉИΠ".isISO3166RegionCodeForm)
        }

        XCTContext.runActivity(named: "count:3, not-ascii, not-upper") { _ in
            XCTAssertFalse("éиπ".isISO3166RegionCodeForm)
        }

        XCTContext.runActivity(named: "count:3, ascii, number") { _ in
            XCTAssertTrue("001".isISO3166RegionCodeForm)
        }

        XCTContext.runActivity(named: "count:3, not-ascii, number") { _ in
            XCTAssertFalse("㊈㊈㊈".isISO3166RegionCodeForm)
        }

    }

    func testIsISO15924ScriptCodeForm() throws {

        // I'm writing very rough tests.
        XCTContext.runActivity(named: "count:3, ull") { _ in
            XCTAssertFalse("Arb".isISO15924ScriptCodeForm)
        }

        XCTContext.runActivity(named: "count:4, ulll") { _ in
            XCTAssertTrue("Arbb".isISO15924ScriptCodeForm)
        }

        XCTContext.runActivity(named: "count:4, llll") { _ in
            XCTAssertFalse("arbb".isISO15924ScriptCodeForm)
        }

    }

}
