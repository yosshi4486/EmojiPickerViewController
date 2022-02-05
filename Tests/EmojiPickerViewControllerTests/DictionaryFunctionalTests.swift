//
//  DictionaryFunctionalTests.swift
//
//  EmojiPickerViewController
//  https://github.com/yosshi4486/EmojiPickerViewController
// 
//  Created by yosshi4486 on 2022/02/05.
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

class DictionaryFunctionalTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    struct Object {
        var value: String
        var group: String
    }

    func testGroupingKeepsOrder() throws {

        let objects: [Object] = [
            Object(value: "A", group: "Cool"),
            Object(value: "Z", group: "Cool"),
            Object(value: "Y", group: "Shy"),
            Object(value: "I", group: "Shy"),
            Object(value: "X", group: "Powerful"),
            Object(value: "J", group: "Powerful"),
        ]

        let dictionary = Dictionary(grouping: objects, by: { $0.group })
        let cool = dictionary["Cool"]!
        let shy = dictionary["Shy"]!
        let powerful = dictionary["Powerful"]!

        XCTAssertEqual(cool.map(\.value), ["A", "Z"])
        XCTAssertEqual(shy.map(\.value), ["Y", "I"])
        XCTAssertEqual(powerful.map(\.value), ["X", "J"])

    }

}
