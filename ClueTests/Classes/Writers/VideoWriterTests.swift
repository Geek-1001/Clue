//
//  VideoWriterTests.swift
//  Clue
//
//  Created by Andrea Prearo on 5/22/17.
//  Copyright © 2017 Ahmed Sulaiman. All rights reserved.
//

import Foundation
import AVFoundation

import XCTest
@testable import Clue

class VideoWriterTests: XCTestCase {
    func testAppendPixelBuffer() {
        // Initialize test variables
        let viewSize = CGSize(width: 375, height: 667)
        let viewScale = CGFloat(2.0)
        let outputURL = URL(fileURLWithPath: "test-video-file.mp4")
        let timeFrame = CMTime(seconds: 4, preferredTimescale: 1000)
        let viewFrame = CGRect(x: 0, y: 0, width: viewSize.width, height: viewSize.height)
        let view = UIView()
        view.frame = viewFrame
        view.backgroundColor = UIColor.red

        let videoFinishExpectation = expectation(description: "Video writing finished")

        // Initialize Video Writer with test variables
        guard let writer = VideoWriter(outputURL: outputURL, viewSize: viewSize, viewScale: viewScale) else {
            XCTFail("Failed to create the video writer instance")
            return
        }

        // Start Writing Process
        writer.startWriting()
        // Video Writer should be ready for writing
        XCTAssertTrue(writer.isReadyForWriting(), "Video Writer is not ready for writing")

        // Set up bitmap context for video content
        let (pixelBuffer, bitmapContext) = writer.createPixelBufferAndBitmapContext()
        guard let buffer = pixelBuffer, let context = bitmapContext else {
            XCTFail("Failed to create the pixel buffer and the bitmap context")
            return
        }

        // Make bitmap context the main context and draw test view on it
        UIGraphicsPushContext(context)
        view.drawHierarchy(in: viewFrame, afterScreenUpdates: false)
        UIGraphicsPopContext()

        // Append pixel buffer with data
        let status = writer.appendPixelBuffer(buffer, timestamp: timeFrame)
        XCTAssertTrue(status, "Can't append the pixel buffer")

        // Clean up the context
        CVPixelBufferUnlockBaseAddress(buffer, [])

        // Finish Writing Process
        writer.finishWriting { 
            do {
                try FileManager.default.removeItem(at: outputURL)
            } catch {
                XCTFail("Error removing test file: \(outputURL)")
            }
            videoFinishExpectation.fulfill()
        }

        waitForExpectations(timeout: 10) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
   }
}
