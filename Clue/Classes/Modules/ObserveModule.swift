//
//  ObserveModule.swift
//  Clue
//
//  Created by Andrea Prearo on 5/6/17.
//  Copyright © 2017 Ahmed Sulaiman. All rights reserved.
//

import Foundation

/// `ObserveModule` is a base class for all modules which needs to observe their data
/// (except `VideoModule` module) and record them only if new data has arrived
/// (like `NetworkModule` or `UserInteractionModule` modules) or something changed with
/// the next frame iteration (like `ViewStructureModule` module). This class is responsible
/// for thread safety of new data writing via Writers and Data Buffer management.
public class ObserveModule: NSObject {
    // MARK: - Private Properties
    fileprivate let writer: JSONWriter
    fileprivate var bufferArray: [[AnyHashable: Any]]?
    fileprivate var frameRecordingSemaphore: DispatchSemaphore?

    var recordQueue: DispatchQueue?

    // MARK: - Public Properties
    /// Indicates whether video recording has started or not
    fileprivate(set) public var isRecording: Bool = false
    /// Current available timestamp. This property updating constantly with
    /// `addNewFrameWithTimestamp:` from `RecordableModule` protocol
    var currentTimestamp: TimeInterval = 0.0

    // MARK: - Lifecycle
    public required init(writer: Writable) {
        self.writer = writer as! JSONWriter
        bufferArray = [[AnyHashable: Any]]()
        currentTimestamp = 0
        recordQueue = DispatchQueue(label: "ObserveModule.recordQueue", qos: .default, attributes: .concurrent, autoreleaseFrequency: .inherit, target: DispatchQueue.global())
        frameRecordingSemaphore = DispatchSemaphore(value: 1)
    }

    // MARK: - Public Methods
    /// Adds a new entry to buffer, so it could be saved to file via Writer
    /// on next iteration of `addNewFrameWithTimestamp:` from `RecordableModule` protocol.
    ///
    /// - Parameter bufferItem: The entry which you need to save to buffer.
    public func addData(bufferItem: [AnyHashable: Any]) {
        recordQueue?.sync {
            bufferArray?.append(bufferItem)
        }
    }

    /// Removes all entries from data buffer
    public func clearBuffer() {
        recordQueue?.sync {
            bufferArray?.removeAll()
        }
    }

    /// Returns a dictionary object for the current timestamp 
    var timestampDictionary: [AnyHashable: Any] {
        return ["timestamp": currentTimestamp]
    }
}

// MARK: - ObserveModule + RecordableModule
extension ObserveModule: RecordableModule {
    public func startRecording() {
        if !isRecording {
            isRecording = true
            writer.startWriting()
        }
    }

    public func stopRecording() {
        if isRecording {
            isRecording = false
            writer.finishWriting()
            clearBuffer()
        }
    }

    /// This method will be called by third-party (see `CLUReportComposer`) when new frame
    /// with new timestamp is available. So usually your module needs to handle all 
    /// recording related operations here and setup specific timestamp for new data entity.
    ///
    /// - Parameter timestamp: `TimeInterval` timestamp of new frame. So module can add
    ///                         new data if available for this timestamp
    public func addNewFrame(for timestamp: TimeInterval) {
        currentTimestamp = timestamp
        if frameRecordingSemaphore?.wait(timeout: DispatchTime.now()) != .success {
            return
        }

        recordQueue?.async { [weak self] in
            guard let strongSelf = self else {
                return
            }
            if let bufferArray = strongSelf.bufferArray, !bufferArray.isEmpty {
                if !strongSelf.writer.isReadyForWriting() {
                    return
                }
                for bufferItem in bufferArray {
                    strongSelf.writer.append(json: bufferItem)
                }
                strongSelf.clearBuffer()
            }
            strongSelf.frameRecordingSemaphore?.signal()
        }
    }

    /// Indicates whether data buffer empty or not
    public var isBufferEmpty: Bool {
        return bufferArray?.count == 0
    }
}
