//
//  Writable.swift
//  Clue
//
//  Created by Andrea Prearo on 5/22/17.
//  Copyright © 2017 Ahmed Sulaiman. All rights reserved.
//

import Foundation

/**
 `Writable` protocol describe writers (like `VideoWriter`) which needs to actually write new data to specific file (could be text file, video file etc.)
 */
public protocol Writable {
    /// Returns whether the writer instance is ready to write new data or not
    func isReadyForWriting() -> Bool

    /// Finishes the actual writing an performs all the necessary cleanup.
    func finishWriting()

    /// Starts the actual writing and performs all the necessary set up.
    func startWriting()
}
