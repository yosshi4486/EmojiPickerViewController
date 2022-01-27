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

        let loader = EmojiLoader()
        let emojis = loader.load()
        XCTAssertEqual(emojis.count, 3633)

        // Assert First and Last
        XCTAssertEqual(emojis.first?.character, "😀")
        XCTAssertEqual(emojis.last?.character, "🏴󠁧󠁢󠁷󠁬󠁳󠁿")
    }


    func testPerformanceLoad() throws {

        let loader = EmojiLoader()

        // loader.load() should be finished less than 0.1sec.
        self.measure {
            _ = loader.load()
        }

    }

}
