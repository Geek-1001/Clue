//
//  JSONWriterTests.swift
//  Clue
//
//  Created by Andrea Prearo on 4/25/17.
//  Copyright © 2017 Ahmed Sulaiman. All rights reserved.
//

import XCTest
@testable import Clue

class JSONWriterTests: XCTestCase {
    fileprivate lazy var testOutputURL: URL = {
        return URL(fileURLWithPath: "test-file")
    }()
    fileprivate lazy var fileManager: FileManager = {
        return FileManager.default
    }()
    fileprivate var writer: JSONWriter?

    override func setUp() {
        super.setUp()
        writer = JSONWriter(outputURL: testOutputURL)
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

    func testAppendValidObject() {
        guard let writer = writer else {
            XCTFail("Invalid JSONWriter instance")
            return
        }
        let json = ["key1": "Test Data String Content"]
        let bytesCount = writer.append(json: json)
        let expectedBytesCount = try? JSONSerialization.data(withJSONObject: json, options: []).count + 1
        XCTAssertEqual(bytesCount, expectedBytesCount)
    }

    func testAppendValidArray() {
        guard let writer = writer else {
            XCTFail("Invalid JSONWriter instance")
            return
        }
        let json = (1..<11).map {
            return ["key\($0)": "Test Data String Content"]
        }
        let bytesCount = writer.append(json: json)
        let expectedBytesCount = try? JSONSerialization.data(withJSONObject: json, options: []).count + 1
        XCTAssertEqual(bytesCount, expectedBytesCount)
    }

    func testAppendInvalidObject() {
        guard let writer = writer else {
            XCTFail("Invalid JSONWriter instance")
            return
        }
        let json = "Invalid JSON Content"
        let bytesCount = writer.append(json: json)
        XCTAssertEqual(bytesCount, 0)
        XCTAssertEqual(writer.error, DataWriterError.invalidJSON(json))
    }
}
