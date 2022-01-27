//
//  EmojiLoaderTests.swift
//  
//
//  Created by yosshi4486 on 2022/01/27.
//

import XCTest
@testable import EmojiPickerViewController

class EmojiLoaderTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLoadEntireEmojiByOrdering() throws {

        // Emoji Counts: https://unicode.org/emoji/charts/emoji-counts.html

        let loadExpectation = expectation(description: "load")
        let loader = EmojiLoader()
        loader.load { emojis in
            XCTAssertEqual(emojis.count, 3633)
            loadExpectation.fulfill()
        }

        wait(for: [loadExpectation], timeout: 1.0)

    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
