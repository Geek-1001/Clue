//
//  VideoWriter.swift
//  Clue
//
//  Created by Andrea Prearo on 5/22/17.
//  Copyright © 2017 Ahmed Sulaiman. All rights reserved.
//

import Foundation
import AVFoundation

public typealias VideoWriterCompletionHandler = () -> Void

/**
 `VideoWriter` class which responsible for all writing and saving process for video stream from device's screen.
 Used with Video Module to record screen while report recording is active
 */
public class VideoWriter: DataWriter {
    var colorSpace: CGColorSpace
    var outputBufferPool: CVPixelBufferPool?
    var videoWriter: AVAssetWriter?
    var videoWriterInput: AVAssetWriterInput?
    var videoWriterAdaptor: AVAssetWriterInputPixelBufferAdaptor?

    fileprivate(set) public var viewSize: CGSize
    fileprivate(set) public var viewScale: CGFloat
    public var status: AVAssetWriterStatus {
        return videoWriter?.status ?? .unknown
    }

    /// Initializes an output stream.
    ///
    /// - Parameter outputURL: The URL for the output stream.
    /// - Parameter viewSize: Size of final video. Depends on recorded view viewSize.
    /// - Parameter viewScale: Current device's screen viewScale. To generate bitmap with correct viewSize depending on viewScale.
    /// - Returns: An initialized output stream for writing to a specified URL.
    public init?(outputURL: URL, viewSize: CGSize, viewScale: CGFloat) {
        self.viewSize = viewSize
        self.viewScale = viewScale
        colorSpace = CGColorSpaceCreateDeviceRGB()
        super.init(outputURL: outputURL)
        setUpOutputPixelBufferPool(viewSize: viewSize, viewScale: viewScale)
        setUpAssetVideoWriter(outputURL: outputURL)
        setupAssetVideoWriterInput(viewSize: viewSize, viewScale: viewScale)
        setUpVideoWriterAdaptor()
    }

    /// Sets up the pixel buffer and the graphic context representing the video content.
    ///
    /// - Returns: A tuple of optionals containing the pixel buffer and the graphic context.
    ///
    public func createPixelBufferAndBitmapContext() -> (CVPixelBuffer?, CGContext?) {
        guard let outputBufferPool = outputBufferPool else {
            assertionFailure("Pixel buffer pool not initialized")
            return (nil, nil)
        }
        var pixelBuffer: CVPixelBuffer?
        CVPixelBufferPoolCreatePixelBuffer(nil, outputBufferPool, &pixelBuffer)
        guard let buffer = pixelBuffer else {
            assertionFailure("Failed to create the pixel buffer")
            return (nil, nil)
        }
        CVPixelBufferLockBaseAddress(buffer, [])
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue | CGBitmapInfo.byteOrder32Little.rawValue)
        let bitmapContext = CGContext(data: CVPixelBufferGetBaseAddress(buffer),
                                      width: CVPixelBufferGetWidth(buffer),
                                      height: CVPixelBufferGetHeight(buffer),
                                      bitsPerComponent: 8,
                                      bytesPerRow: CVPixelBufferGetBytesPerRow(buffer),
                                      space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        guard let context = bitmapContext else {
            assertionFailure("Failed to create the bitmap context")
            return (nil, bitmapContext)
        }
        context.scaleBy(x: viewScale, y: viewScale)
        let flipVertical = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: viewSize.height)
        context.concatenate(flipVertical)
        return (pixelBuffer, bitmapContext)
    }
    
    /// Appends a buffer for writing.
    ///
    /// - Parameters:
    ///   - pixelBuffer: The pixel buffer representing the video content.
    ///   - timestamp: The buffer timestamp.
    /// - Returns: Wheter the appending operation was successful.
    public func appendPixelBuffer(_ pixelBuffer: CVPixelBuffer, timestamp: CMTime) -> Bool {
        return videoWriterAdaptor?.append(pixelBuffer, withPresentationTime: timestamp) ?? false
    }
    
    /// Finish actual writing with all necessary cleanup (Internal method for testing).
    ///
    /// - Parameter completionHandler: The completion handler to be executed after finishing writing.
    func finishWriting(completionHandler: VideoWriterCompletionHandler?) {
        videoWriterInput?.markAsFinished()
        videoWriter?.finishWriting {  [weak self] in
            completionHandler?()
            guard let strongSelf = self else {
                return
            }
            strongSelf.videoWriterAdaptor = nil
            strongSelf.videoWriterInput = nil
            strongSelf.videoWriter = nil
        }
    }
}

// MARK: - VideoWriter + Writable
public extension VideoWriter {
    override func isReadyForWriting() -> Bool {
        return videoWriterInput?.isReadyForMoreMediaData ?? false
    }

    override func startWriting() {
        videoWriter?.startWriting()
        videoWriter?.startSession(atSourceTime: kCMTimeZero)
    }

    override func finishWriting() {
        finishWriting(completionHandler: nil)
    }
}

// MARK: - private Methods
fileprivate extension VideoWriter {
    func setUpOutputPixelBufferPool(viewSize: CGSize, viewScale: CGFloat) {
        let bufferAttributes: NSDictionary = [
            kCVPixelBufferPixelFormatTypeKey: kCVPixelFormatType_32BGRA,
            kCVPixelBufferCGBitmapContextCompatibilityKey: true,
            kCVPixelBufferWidthKey: viewSize.width * viewScale,
            kCVPixelBufferHeightKey: viewSize.height * viewScale,
            kCVPixelBufferBytesPerRowAlignmentKey: viewSize.width * viewScale * 4
        ]
        CVPixelBufferPoolCreate(nil, nil, bufferAttributes, &outputBufferPool)
        guard let _ = outputBufferPool else {
            assertionFailure("Failed to create the pixel buffer pool")
            return
        }
    }

    func setUpAssetVideoWriter(outputURL: URL) {
        do {
            videoWriter = try AVAssetWriter(url: outputURL, fileType: AVFileTypeQuickTimeMovie)
        } catch {
            assertionFailure("Failed to create the asset writer")
        }
    }

    func setupAssetVideoWriterInput(viewSize: CGSize, viewScale: CGFloat) {
        let pixelCount = viewSize.width * viewSize.height * viewScale
        let videoCompression = [AVVideoAverageBitRateKey: pixelCount * 11.4]
        let videoSettings: [String: Any] = [
            AVVideoCodecKey: AVVideoCodecH264,
            AVVideoWidthKey: viewSize.width * viewScale,
            AVVideoHeightKey: viewSize.height * viewScale,
            AVVideoCompressionPropertiesKey: videoCompression
        ]
        videoWriterInput = AVAssetWriterInput(mediaType: AVMediaTypeVideo,
                                              outputSettings: videoSettings)
        guard let videoWriterInput = videoWriterInput else {
            assertionFailure("Failed to create the asset writer input")
            return
        }
        assert(videoWriter?.canAdd(videoWriterInput) ?? false)
        videoWriter?.add(videoWriterInput)
    }

    func setUpVideoWriterAdaptor() {
        guard let videoWriterInput = videoWriterInput else {
            assertionFailure("Asset writer input not initialized")
            return
        }
        videoWriterAdaptor =
            AVAssetWriterInputPixelBufferAdaptor(assetWriterInput: videoWriterInput,
                                                 sourcePixelBufferAttributes: nil)
        guard let _ = videoWriterAdaptor else {
            assertionFailure("Failed to create the asset writer adaptor")
            return
        }
    }
}
