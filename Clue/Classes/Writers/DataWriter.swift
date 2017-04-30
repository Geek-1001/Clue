//
//  DataWriter.swift
//  Clue
//
//  Created by Andrea Prearo on 4/29/17.
//  Copyright © 2017 Ahmed Sulaiman. All rights reserved.
//

import Foundation

/// The `DataWriter` class encapsulates the details of writing data to a stream.
public class DataWriter: NSObject {
    let outputStream: OutputStream
    var currentError: DataWriterError?

    /// The current error.
    public var error: DataWriterError? {
        if let currentError = currentError {
            return currentError
        }
        guard let streamError = outputStream.streamError else {
            return nil
        }
        return DataWriterError.error(streamError)
    }

    /// Initializes an output stream.
    ///
    /// - Parameter outputURL: The URL for the output stream.
    /// - Returns: An initialized output stream for writing to a specified URL.
    public init?(outputURL: URL) {
        guard let outputStream = OutputStream(url: outputURL, append: true) else {
            return nil
        }
        self.outputStream = outputStream
        super.init()
        self.outputStream.delegate = self
    }

    deinit {
        finishWriting()
    }

    /// Appends data to the stream.
    ///
    /// - Parameter data: The data to be written.
    /// - Returns: The number of bytes that were written. In case the return value
    ///             is zero, the `error` property will contain the current error.
    @discardableResult
    public func append(data: Data) -> Int {
        if !isReadyForWriting() {
            startWriting()
        }
        let bytes = data.withUnsafeBytes { outputStream.write($0, maxLength: data.count) }
        guard bytes > 0 else {
            handleStreamError()
            return bytes
        }

        return bytes
    }
}

// MARK: - DataWriter + StreamDelegate
extension DataWriter: StreamDelegate {
    public func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        switch eventCode {
        case Stream.Event.errorOccurred:
            handleStreamError()
        default:
            return
        }
    }
}

// MARK: - DataWriter + CLUWritable
extension DataWriter: CLUWritable {
    public func isReadyForWriting() -> Bool {
        return outputStream.streamStatus == .open
    }

    public func startWriting() {
        if outputStream.streamStatus != .open {
            outputStream.open()
        }
    }

    public func finishWriting() {
        if outputStream.streamStatus != .closed {
            outputStream.close()
        }
    }
}

// MARK: - Internal Methods
extension DataWriter {
    func handleStreamError() {
        let error = outputStream.streamError ?? currentError
        print("Stream error: \(String(describing: error?.localizedDescription))")
    }
}
