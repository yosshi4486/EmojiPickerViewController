//
//  EmojiLabelTests.swift
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
@testable import EmojiPickerViewController

class EmojiLabelTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLocalizedDescription() throws {

        XCTContext.runActivity(named: "Group: Smileys & Emotion") { _ in

            let label = EmojiLabel(group: "Smileys & Emotion")
            XCTAssertEqual(label, .smileysPeople)

        }

        XCTContext.runActivity(named: "Group: People & Body") { _ in

            let label = EmojiLabel(group: "People & Body")
            XCTAssertEqual(label, .smileysPeople)
        }

        XCTContext.runActivity(named: "Group: Food & Drink") { _ in

            let label = EmojiLabel(group: "Food & Drink")
            XCTAssertEqual(label, .foodDrink)
        }

        XCTContext.runActivity(named: "Group: Travel & Places") { _ in

            let label = EmojiLabel(group: "Travel & Places")
            XCTAssertEqual(label, .travelPlaces)

        }

        XCTContext.runActivity(named: "Group: Activities") { _ in

            let label = EmojiLabel(group: "Activities")
            XCTAssertEqual(label, .activities)


        }

        XCTContext.runActivity(named: "Group: Objects") { _ in

            let label = EmojiLabel(group: "Objects")
            XCTAssertEqual(label, .objects)

        }

        XCTContext.runActivity(named: "Group: Symbols") { _ in

            let label = EmojiLabel(group: "Symbols")
            XCTAssertEqual(label, .symbols)

        }

        XCTContext.runActivity(named: "Group: Flags") { _ in

            let label = EmojiLabel(group: "Flags")
            XCTAssertEqual(label, .flags)

        }


    }


}
