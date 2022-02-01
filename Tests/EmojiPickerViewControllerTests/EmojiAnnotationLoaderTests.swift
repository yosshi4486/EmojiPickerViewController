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

            let loader = EmojiAnnotationLoader(emojiDictionary: [:], languageCode: "zh-Hant-HK")
            XCTAssertEqual(loader.resourceURL, baseURL?.appendingPathComponent("zh_Hant_HK.xml"))

        }

        XCTContext.runActivity(named: "File Not Exist") { _ in

            let loader = EmojiAnnotationLoader(emojiDictionary: [:], languageCode: "a-b-c-d")
            XCTAssertNil(loader.resourceURL)

        }

    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
