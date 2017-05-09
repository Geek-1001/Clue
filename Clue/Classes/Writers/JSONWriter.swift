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
    /// - Returns: The result of writing to the stream. This will either be the
    ///             number of bytes that were written, or an error. In case the return
    ///             value is zero, the `error` property will contain the current error.
    @discardableResult
    public func append(json: Any) -> Result<Int, DataWriterError> {
        guard JSONSerialization.isValidJSONObject(json) else {
            let error = DataWriterError.invalidJSON(json)
            setError(error)
            return .failure(error)
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
            return .failure(validError)
        }

        let lineSeparator = "\n"
        guard let stringData = lineSeparator.data(using: .utf8) else {
            let error = DataWriterError.invalidJSON(lineSeparator)
            setError(error)
            return .failure(error)
        }
        let result = append(data: stringData)
        if let lineSeparatorBytes = result.value {
            return .success(bytes + lineSeparatorBytes)
        } else if let resultError = result.error {
            setError(resultError)
            return .failure(resultError)
        }
        return .failure(.unknown)
    }
}
