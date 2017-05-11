//
//  ObserveModuleTests.swift
//  Clue
//
//  Created by Andrea Prearo on 5/9/17.
//  Copyright © 2017 Ahmed Sulaiman. All rights reserved.
//

import XCTest
@testable import Clue

class ObserveModuleTests: XCTestCase {
    static fileprivate let testOutputURL = URL(fileURLWithPath: "test-file")

    fileprivate lazy var observeModule: ObserveModule = {
        let writer = JSONWriter(outputURL: ObserveModuleTests.testOutputURL)
        return ObserveModule(writer: writer!)
    }()

    override func tearDown() {
        do {
            try FileManager.default.removeItem(at: ObserveModuleTests.testOutputURL)
        } catch {
            XCTFail("Unexpected error while removing Test Output File")
        }
        super.tearDown()
    }

    func testAddDataToBuffer() {
        // Initialize test variables
        let testData = ["key": "test-content"]

        // Start recording
        observeModule.startRecording()
        XCTAssertTrue(observeModule.isRecording, "Observe Module isRecording property is incorrect after startRecording:")

        // Check Buffer for empty
        XCTAssertTrue(observeModule.isBufferEmpty, "Observe Module Buffer is not empty after recoding")

        // Add data
        observeModule.addData(bufferItem: testData)
        XCTAssertFalse(observeModule.isBufferEmpty, "Observe Module Buffer is empty after addData: call")

        // Clear buffer
        observeModule.clearBuffer()
        XCTAssertTrue(observeModule.isBufferEmpty, "Observe Module Buffer is not empty after clearBuffer:")

        // Stop recording
        observeModule.stopRecording()
        XCTAssertFalse(observeModule.isRecording, "Observe Module isRecording property is incorrect after stopRecording:")
    }
}
