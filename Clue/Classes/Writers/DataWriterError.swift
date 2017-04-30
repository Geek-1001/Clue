//
//  DataWriterError.swift
//  Clue
//
//  Created by Andrea Prearo on 4/25/17.
//  Copyright © 2017 Ahmed Sulaiman. All rights reserved.
//

import Foundation

/// An error that can be returned from a `DataWriter` instance.
///
/// - error: Internal error.
/// - failure: Internal failure.
/// - invalidData: Invalid data.
/// - invalidJSON: Invalid JSON content.
/// - unknown: Unknown error.
public enum DataWriterError: Error {
    case error(Error)
    case failure(NSError)
    case invalidData(Data)
    case invalidJSON(Any)
    case unknown
}

extension DataWriterError: Equatable {}

public func == (lhs: DataWriterError, rhs: DataWriterError) -> Bool {
    switch lhs {
    case .error(let error):
        switch rhs {
        case .error(let error2):
            return String(describing: error) == String(describing: error2)
        default:
            return false
        }
    case .failure(let error):
        switch rhs {
        case .failure(let error2):
            return error == error2
        default:
            return false
        }
    case .invalidData(let data):
        switch rhs {
        case .invalidData(let data2):
            return data == data2
        default:
            return false
        }
    case .invalidJSON(let json):
        switch rhs {
        case .invalidJSON(let json2):
            return String(describing: json) == String(describing: json2)
        default:
            return false
        }
    case .unknown:
        switch rhs {
        case .unknown:
            return true
        default:
            return false
        }
    }
}
