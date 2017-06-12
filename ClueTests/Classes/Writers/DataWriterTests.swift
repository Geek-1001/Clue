//
//  DataWriterTests.swift
//  Clue
//
//  Created by Andrea Prearo on 4/29/17.
//  Copyright © 2017 Ahmed Sulaiman. All rights reserved.
//

import XCTest
@testable import Clue

class DataWriterTests: XCTestCase {
    fileprivate lazy var outputURL: URL = {
        return URL(fileURLWithPath: "test-file")
    }()
    fileprivate lazy var fileManager: FileManager = {
        return FileManager.default
    }()
    fileprivate var writer: DataWriter?

    override func setUp() {
        super.setUp()
        writer = DataWriter(outputURL: outputURL)
        writer?.startWriting()
    }

    override func tearDown() {
        writer?.finishWriting()
        do {
            try fileManager.removeItem(at: outputURL)
        } catch {
            XCTFail("Error removing test file: \(outputURL)")
        }
        super.tearDown()
    }

    func testAppendValidData() {
        guard let writer = writer else {
            XCTFail("Invalid DataWriter instance")
            return
        }
        let content = "Test Data String Content"
        guard let contentData = content.data(using: .utf8) else {
            XCTFail("Invalid data")
            return
        }
        let result = writer.append(data: contentData)
        let expectedBytesCount = content.characters.count
        XCTAssertEqual(result.value, expectedBytesCount)
        XCTAssertNil(writer.error)
    }

    func testAppendEmptyData() {
        guard let writer = writer else {
            XCTFail("Invalid DataWriter instance")
            return
        }
        let content = ""
        guard let contentData = content.data(using: .utf8) else {
            XCTFail("Invalid data")
            return
        }
        let result = writer.append(data: contentData)
        XCTAssertEqual(result.value, 0)
        XCTAssertNil(writer.error)
    }
}
