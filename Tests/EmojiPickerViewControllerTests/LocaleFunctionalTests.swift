//
//  LocaleFunctionalTests.swift
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

class LocaleFunctionalTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    /*
     Locale object can understand and store the given identifier regardless the format is hyphen or underscore.
     */

    func testIdentifierHyphen() throws {

        let locale = Locale(identifier: "de-CH")
        XCTAssertEqual(locale.identifier, "de-CH")

    }

    func testIdentifierUnderScore() throws {

        let locale = Locale(identifier: "de_CH")
        XCTAssertEqual(locale.identifier, "de_CH")

    }

    func testLocaleRoundIdentifer() throws {

        let langageCode = "sr"
        let scriptCode = "Cyrl"
        let regionCode = "BA"

        let identifier = "\(langageCode)-\(scriptCode)_\(regionCode)"
        let foundationLocale = Locale(identifier: identifier)
        XCTAssertNotEqual(foundationLocale.identifier, identifier)
        XCTAssertEqual(foundationLocale.identifier, "sr_BA")

        XCTAssertEqual(foundationLocale.languageCode, "sr")
        XCTAssertNil(foundationLocale.scriptCode)
        XCTAssertEqual(foundationLocale.regionCode, "BA")

    }

}
