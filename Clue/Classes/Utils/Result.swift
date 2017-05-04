//
//  Result.swift
//  Clue
//
//  Created by Andrea Prearo on 5/3/17.
//  Copyright © 2017 Ahmed Sulaiman. All rights reserved.
//

import Foundation

public enum Result<T, ErrorType> {
    case success(T)
    case failure(ErrorType)
}

extension Result {
    var value: T? {
        guard case .success(let validValue) = self else {
            return nil
        }
        return validValue
    }

    var error: ErrorType? {
        guard case .failure(let errorValue) = self else {
            return nil
        }
        return errorValue
    }
}
