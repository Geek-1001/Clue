//
//  Dictionary+Util.swift
//  Clue
//
//  Created by Andrea Prearo on 5/8/17.
//  Copyright © 2017 Ahmed Sulaiman. All rights reserved.
//

import Foundation

extension Dictionary {
    /// Returns a new dictionary containing the entries of this instance and another dictionary passed as a parameter.
    ///
    /// - Parameter other: The dictionary to use for the merge operation.

    /// - Returns: A new dictionary containing the entries of this instance and another dictionary passed as a parameter.
    func merged(with other: Dictionary) -> Dictionary {
        var returnDictionary = self
        for (key, value) in other {
            returnDictionary[key] = value
        }
        return returnDictionary
    }
}
