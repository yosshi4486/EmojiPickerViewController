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

    // MARK: - Testing EmojiLoader

    func testLoadEntireEmojiByOrdering() throws {

        // Emoji Counts: https://unicode.org/emoji/charts/emoji-counts.html
        // The result should ignore component's count from the total counts.
        // 3633 - 9(compoents) = 3624

        let loader = EmojiLoader()
        let emojis = loader.load()
        XCTAssertEqual(emojis.count, 3624)

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

    // MARK: - Testing EmojiLoader.Row

    func testInitCommentRow() {

        let line = "# This is test comment"
        let row = EmojiLoader.Row(line)
        XCTAssertEqual(row, .comment)

    }

    func testInitUnformatedRowFailOver() {

        let line = "こんにちわ！"
        let row = EmojiLoader.Row(line)
        XCTAssertEqual(row, .comment)

    }

    func testInitGroupHeaderRow() {

        let line = "# group: Smileys & Emotion"
        let row = EmojiLoader.Row(line)
        XCTAssertEqual(row, .groupHeader(groupName: "Smileys & Emotion"))

    }

    func testInitGroupHeaderRowFailOver() {

        let line = "# group:" // Doesn't have group name
        let row = EmojiLoader.Row(line)
        XCTAssertEqual(row, .comment)
        
    }

    func testInitSubgroupHeaderRow() {

        let line = "# subgroup: face-smiling"
        let row = EmojiLoader.Row(line)
        XCTAssertEqual(row, .subgroupHeader(suggroupName: "face-smiling"))
    }

    func testInitSubgroupHeaderFailOver() {

        let line = "# subgroup:"
        let row = EmojiLoader.Row(line)
        XCTAssertEqual(row, .comment)
    }

    // MARK: - Testing EmojiLoader.Data

    func testInitDataWhenFullyQualified() throws {

        let dataRowString = """
        1F93E 200D 2642 FE0F                                   ; fully-qualified     # 🤾‍♂️ E4.0 man playing handball
        """

        let data = try XCTUnwrap(EmojiLoader.Data(dataRowString: dataRowString))

        XCTAssertEqual(data.unicodeScalars.map({ $0.value }), [
            UInt32("1F93E", radix: 16)!,
            UInt32("200D", radix: 16)!,
            UInt32("2642", radix: 16)!,
            UInt32("FE0F", radix: 16)!
        ])

        XCTAssertEqual(data.status, .fullyQualified)

    }

    func testInitDataWhenMinimallyQualified() throws {

        let dataRowString = """
        26F9 1F3FF 200D 2642                                   ; minimally-qualified # ⛹🏿‍♂ E4.0 man bouncing ball: dark skin tone
        """

        let data = try XCTUnwrap(EmojiLoader.Data(dataRowString: dataRowString))

        XCTAssertEqual(data.unicodeScalars.map({ $0.value }), [
            UInt32("26F9", radix: 16)!,
            UInt32("1F3FF", radix: 16)!,
            UInt32("200D", radix: 16)!,
            UInt32("2642", radix: 16)!
        ])

        XCTAssertEqual(data.status, .minimallyQualified)

    }

    func testInitDataWhenUnqualified() throws {

        let dataRowString = """
        1F575                                                  ; unqualified         # 🕵 E0.7 detective
        """

        let data = try XCTUnwrap(EmojiLoader.Data(dataRowString: dataRowString))

        XCTAssertEqual(data.unicodeScalars.map({ $0.value }), [
            UInt32("1F575", radix: 16)!,
        ])

        XCTAssertEqual(data.status, .unqualified)

    }

    func testInitDataWhenComponent() throws {

        let dataRowString = """
        1F3FB                                                  ; component           # 🏻 E1.0 light skin tone
        """

        let data = try XCTUnwrap(EmojiLoader.Data(dataRowString: dataRowString))

        XCTAssertEqual(data.unicodeScalars.map({ $0.value }), [
            UInt32("1F3FB", radix: 16)!,
        ])

        XCTAssertEqual(data.status, .component)

    }

    func testInitDataWhenCommentNotFound() throws {

        let dataRowString = """
        1F469 200D 2764 FE0F 200D 1F48B 200D 1F469             ; fully-qualified
        """

        let data = try XCTUnwrap(EmojiLoader.Data(dataRowString: dataRowString))

        XCTAssertEqual(data.unicodeScalars, ["\u{1F469}", "\u{200D}", "\u{2764}", "\u{FE0F}", "\u{200D}", "\u{1F48B}", "\u{200D}", "\u{1F469}"])

        XCTAssertEqual(data.status, .fullyQualified)

    }

    // MARK: - Testing EmojiLoader.Data.Status

    func testInitStatusComponent() throws {

        XCTAssertEqual(EmojiLoader.Data.Status(rawValue: "component"), .component)

    }

    func testInitStatusFullyQualified() throws {

        XCTAssertEqual(EmojiLoader.Data.Status(rawValue: "fully-qualified"), .fullyQualified)

    }

    func testInitStatusMinimallyQualified() throws {

        XCTAssertEqual(EmojiLoader.Data.Status(rawValue: "minimally-qualified"), .minimallyQualified)

    }

    func testInitStatusUnqualified() throws {

        XCTAssertEqual(EmojiLoader.Data.Status(rawValue: "unqualified"), .unqualified)

    }

    func testInitStatusUnknownNil() throws {

        XCTAssertNil(EmojiLoader.Data.Status(rawValue: "unknown"))

    }

}
