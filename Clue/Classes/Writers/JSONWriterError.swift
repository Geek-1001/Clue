//
//  JSONWriterError.swift
//  Clue
//
//  Created by Prearo, Andrea on 4/25/17.
//  Copyright © 2017 Ahmed Sulaiman. All rights reserved.
//

import Foundation

public enum JSONWriterError: Error {
    case unknown
    case invalidObject(Any)
    case failure(NSError)
}

extension JSONWriterError: Equatable {}

public func == (lhs: JSONWriterError, rhs: JSONWriterError) -> Bool {
    switch lhs {
    case .unknown:
        switch rhs {
        case .unknown:
            return true
        default:
            return false
        }
    case .invalidObject(let object):
        switch rhs {
        case .invalidObject(let object2):
            return String(describing: object) == String(describing: object2)
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
    }
}
