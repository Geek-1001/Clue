//
//  DataWriterErrorTests.swift
//  Clue
//
//  Created by Andrea Prearo on 4/25/17.
//  Copyright © 2017 Ahmed Sulaiman. All rights reserved.
//

import Foundation

import XCTest
@testable import Clue

class DataWriterErrorTests: XCTestCase {
    func testSameInvalidObject() {
        let json = "This is not a valid JSON"
        XCTAssertTrue(DataWriterError.invalidJSON(json) == DataWriterError.invalidJSON("This is not a valid JSON"))
    }

    func testDifferentInvalidObject() {
        let json = "This is not a valid JSON"
        XCTAssertFalse(DataWriterError.invalidJSON(json) == DataWriterError.invalidJSON("This is a different invalid JSON"))
    }

    func testSameFailure() {
        let domain = "com.testdomain"
        let code = 123
        let error1 = NSError(domain: domain, code: code, userInfo: nil)
        let error2 = NSError(domain: "com.testdomain", code: 123, userInfo: nil)
        XCTAssertTrue(DataWriterError.failure(error1) == DataWriterError.failure(error2))
    }

    func testDifferentFailureDomain() {
        let domain = "com.testdomain"
        let code = 123
        let error1 = NSError(domain: domain, code: code, userInfo: nil)
        let error2 = NSError(domain: "com.newtestdomain", code: 123, userInfo: nil)
        XCTAssertFalse(DataWriterError.failure(error1) == DataWriterError.failure(error2))
    }

    func testDifferentFailureCode() {
        let domain = "com.testdomain"
        let code = 123
        let error1 = NSError(domain: domain, code: code, userInfo: nil)
        let error2 = NSError(domain: "com.testdomain", code: 1234, userInfo: nil)
        XCTAssertFalse(DataWriterError.failure(error1) == DataWriterError.failure(error2))
    }

    func testDifferentFailureUserInfo() {
        let domain = "com.testdomain"
        let code = 123
        let error1 = NSError(domain: domain, code: code, userInfo: nil)
        let error2 = NSError(domain: "com.testdomain", code: 123, userInfo: ["key": "some uesr info"])
        XCTAssertFalse(DataWriterError.failure(error1) == DataWriterError.failure(error2))
    }
}
