//
//  JSONWriter.swift
//  Clue
//
//  Created by Andrea Prearo on 4/25/17.
//  Copyright © 2017 Ahmed Sulaiman. All rights reserved.
//

import Foundation

/// The `JSONWriter` class encapsulates the details of writing JSON data to a stream.
public class JSONWriter: DataWriter {
    /// Appends JSON content.
    ///
    /// - Parameter json: The JSON content to append.
    /// - Returns: The number of bytes that were appended. In case the return value
    ///             is zero, the `error` property will contain the current error.
    @discardableResult
    public func append(json: Any) -> Int {
        guard JSONSerialization.isValidJSONObject(json) else {
            currentError = DataWriterError.invalidJSON(json)
            handleStreamError()
            return 0
        }
        var error: NSError?
        if !isReadyForWriting() {
            startWriting()
        }
        let bytes = JSONSerialization.writeJSONObject(json, to: outputStream, options: [], error: &error)
        guard bytes > 0 else {
            if let error = error {
                currentError = DataWriterError.failure(error)
            } else {
                currentError = DataWriterError.unknown
            }
            handleStreamError()
            return bytes
        }

        let lineSeparator = "\n"
        guard let stringData = lineSeparator.data(using: .utf8) else {
            currentError = DataWriterError.invalidJSON(lineSeparator)
            handleStreamError()
            return bytes
        }
        let lineSeparatorBytes = append(data: stringData)
        if lineSeparatorBytes != 1 {
            currentError = DataWriterError.unknown
            handleStreamError()
            return bytes
        }

        return bytes + lineSeparatorBytes
    }
}
