//
//  EmojiUpdateTests.swift
//
//  EmojiPickerViewController
//  https://github.com/yosshi4486/EmojiPickerViewController
// 
//  Created by David Kennedy on 10/05/2023.
//
// ----------------------------------------------------------------------------
//
//  © 2023  yosshi4486
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

final class EmojiUpdateTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    // MARK: - Testing Emoji Generation
    
    func testEmojiGeneration() throws {
        
        let latestGenEmoji = Character("🫠")
        let nextGenEmoji = Character("🫨")
        
        XCTAssertTrue(latestGenEmoji.unicodeScalars.first!.properties.isEmoji)
        XCTAssertFalse(nextGenEmoji.unicodeScalars.first!.properties.isEmoji, "Time to upgrade to latest emoji standard, and change this test!")
        
    }

}
