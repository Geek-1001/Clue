//
//  VideoModule.swift
//  Clue
//
//  Created by Andrea Prearo on 5/22/17.
//  Copyright © 2017 Ahmed Sulaiman. All rights reserved.
//

import Foundation
import AVFoundation

/**
 `VideoModule` is a class (module) for screen recording which implements `RecordableModule` protocol.
 It's responsible for thread safety while video recording, operations with `CVPixelBuffer` and 
 current view hierarchy drawing (see `UIView` `drawViewHierarchyInRect:afterScreenUpdates:`) and frames overlapping while recording.
 */
public class VideoModule: NSObject {
    // MARK: - Private Properties
    fileprivate let writer: VideoWriter
    fileprivate var renderQueue: DispatchQueue?
    fileprivate var appendPixelBufferQueue: DispatchQueue?
    fileprivate var frameRenderingSemaphore: DispatchSemaphore?
    fileprivate var pixelAppendSemaphore: DispatchSemaphore?

    fileprivate(set) public var isRecording = false

    public required init(writer: Writable) {
        self.writer = writer as! VideoWriter
        isRecording = false

        appendPixelBufferQueue = DispatchQueue(label: "VideoModule.appendPixelBufferQueue")
        renderQueue = DispatchQueue(label: "CLURecorder.renderQueue", qos: .default, attributes: .concurrent, autoreleaseFrequency: .inherit, target: DispatchQueue.global())
        frameRenderingSemaphore = DispatchSemaphore(value: 1)
        pixelAppendSemaphore = DispatchSemaphore(value: 1)
    }
}

// MARK: - VideoModule + RecordableModule
extension VideoModule: RecordableModule {
    public func startRecording() {
        if !isRecording {
            writer.startWriting()
            isRecording = (writer.status == .writing)
        }
    }

    public func stopRecording() {
        if isRecording {
            isRecording = false
            writer.finishWriting()
        }
    }

    public func addNewFrame(for timestamp: TimeInterval) {
        // Throttle the number of frames to prevent meltdown.
        // Technique gleaned from Brad Larson's answer here: http://stackoverflow.com/a/5956119
        if frameRenderingSemaphore?.wait(timeout: DispatchTime.now()) != .success {
            return
        }

        renderQueue?.async { [weak self] in
            guard let strongSelf = self else {
                return
            }
            if !strongSelf.writer.isReadyForWriting() {
                return
            }

            let currentTime = CMTime(seconds: timestamp, preferredTimescale: 1000)
            let (pixelBuffer, bitmapContext) = strongSelf.writer.createPixelBufferAndBitmapContext()
            guard let buffer = pixelBuffer, let context = bitmapContext else {
                return
            }

            DispatchQueue.main.sync {
                UIGraphicsPushContext(context)
                let viewFrame = CGRect(x: 0, y: 0, width: strongSelf.writer.viewSize.width, height: strongSelf.writer.viewSize.height)
                for window in UIApplication.shared.windows {
                    window.drawHierarchy(in: viewFrame, afterScreenUpdates: false)
                }
                UIGraphicsPopContext()
            }

            if strongSelf.pixelAppendSemaphore?.wait(timeout: DispatchTime.now()) == .success {
                strongSelf.appendPixelBufferQueue?.async {
                    guard strongSelf.writer.appendPixelBuffer(buffer, timestamp: currentTime) else {
                        // TODO: inform WARNING unable to append pixelBuffer
                        return
                    }
                }
                CVPixelBufferUnlockBaseAddress(buffer, [])

                strongSelf.pixelAppendSemaphore?.signal()
            } else {
                CVPixelBufferUnlockBaseAddress(buffer, [])
            }

            strongSelf.frameRenderingSemaphore?.signal()
        }
    }
}
