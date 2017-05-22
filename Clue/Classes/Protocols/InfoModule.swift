//
//  InfoModule.swift
//  Clue
//
//  Created by Andrea Prearo on 5/22/17.
//  Copyright © 2017 Ahmed Sulaiman. All rights reserved.
//

import Foundation

/**
 `InfoModule` protocol describe info modules (like Device Info module or Exception module),
 static one-time modules which needs to write their data only once during recording.

 @warning Every info module has to implement this protocol to be able to work as expected inside the system.
 */
public protocol InfoModule {
    /// Initializes the info module with a specific writer which implements the `Writable` protocol.
    /// This will in turn allow the info module to record/write all required data.
    ///
    /// - Parameter writer: The Writer object which implements the `Writable` protocol.
    ///                     It will be responsible for writing the actual data to a specific file.
    init(writer: Writable)

    /// Triggers the recording of the actual data and takes care of the cleanup process.
    func recordInfoData()
}
