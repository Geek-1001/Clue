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
    fileprivate lazy var outputURL: URL = {
        return URL(fileURLWithPath: "test-file")
    }()
    fileprivate lazy var fileManager: FileManager = {
        return FileManager.default
    }()
    fileprivate var writer: JSONWriter?

    override func setUp() {
        super.setUp()
        writer = JSONWriter(outputURL: outputURL)
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

    func testAppendValidObject() {
        guard let writer = writer else {
            XCTFail("Invalid JSONWriter instance")
            return
        }
        let json = ["key1": "Test Data String Content"]
        let result = writer.append(json: json)
        let expectedBytesCount = try? JSONSerialization.data(withJSONObject: json, options: []).count + 1
        XCTAssertEqual(result.value, expectedBytesCount)
    }

    func testAppendValidArray() {
        guard let writer = writer else {
            XCTFail("Invalid JSONWriter instance")
            return
        }
        let json = (1..<11).map {
            return ["key\($0)": "Test Data String Content"]
        }
        let result = writer.append(json: json)
        let expectedBytesCount = try? JSONSerialization.data(withJSONObject: json, options: []).count + 1
        XCTAssertEqual(result.value, expectedBytesCount)
    }

    func testAppendInvalidObject() {
        guard let writer = writer else {
            XCTFail("Invalid JSONWriter instance")
            return
        }
        let json = "Invalid JSON Content"
        let result = writer.append(json: json)
        XCTAssertNil(result.value)
        XCTAssertEqual(writer.error, DataWriterError.invalidJSON(json))
    }
}
