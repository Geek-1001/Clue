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
    fileprivate lazy var testOutputURL: URL = {
        return URL(fileURLWithPath: "test-file")
    }()
    fileprivate lazy var fileManager: FileManager = {
        return FileManager.default
    }()
    fileprivate var writer: DataWriter?

    override func setUp() {
        super.setUp()
        writer = DataWriter(outputURL: testOutputURL)
        writer?.startWriting()
    }

    override func tearDown() {
        writer?.finishWriting()
        do {
            try fileManager.removeItem(at: testOutputURL)
        } catch {
            XCTFail("Error removing test file: \(testOutputURL)")
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
        let bytesCount = writer.append(data: contentData)
        let expectedBytesCount = content.characters.count
        XCTAssertEqual(bytesCount, expectedBytesCount)
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
        let bytesCount = writer.append(data: contentData)
        XCTAssertEqual(bytesCount, 0)
        XCTAssertNil(writer.error)
    }
}
