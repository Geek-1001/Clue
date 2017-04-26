//
//  JSONWriter.swift
//  Clue
//
//  Created by Prearo, Andrea on 4/25/17.
//  Copyright © 2017 Ahmed Sulaiman. All rights reserved.
//

import Foundation

public class JSONWriter: NSObject {
    fileprivate let outputStream: OutputStream
    fileprivate var currentError: JSONWriterError?

    public var error: JSONWriterError? {
        return currentError
    }

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

    @discardableResult
    public func append(json: Any) -> Bool {
        guard JSONSerialization.isValidJSONObject(json) else {
            currentError = JSONWriterError.invalidObject(json)
            handleStreamError()
            return false
        }
        var error: NSError?
        if !isReadyForWriting() {
            startWriting()
        }
        let bytes = JSONSerialization.writeJSONObject(json, to: outputStream, options: [], error: &error)
        guard bytes > 0 else {
            if let error = error {
                currentError = JSONWriterError.failure(error)
            } else {
                currentError = JSONWriterError.unknown
            }
            handleStreamError()
            return false
        }

        let lineSeparator = "\n"
        guard let stringData = lineSeparator.data(using: .utf8) else {
            currentError = JSONWriterError.invalidObject(lineSeparator)
            handleStreamError()
            return false
        }
        let dataBytes = stringData.withUnsafeBytes { outputStream.write($0, maxLength: stringData.count) }
        if dataBytes != 1 {
            currentError = JSONWriterError.unknown
            handleStreamError()
            return false
        }

        return true
    }
}

// MARK: - JSONWriter + StreamDelegate
extension JSONWriter: StreamDelegate {
    public func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        switch eventCode {
        case Stream.Event.errorOccurred:
            handleStreamError()
        default:
            return
        }
    }
}

// MARK: - JSONWriter + CLUWritable
extension JSONWriter: CLUWritable {
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

// MARK: - Private Methods
fileprivate extension JSONWriter {
    func handleStreamError() {
        let error = outputStream.streamError ?? currentError
        print("Stream error: \(String(describing: error?.localizedDescription))")
    }
}
