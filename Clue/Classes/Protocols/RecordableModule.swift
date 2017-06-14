//
//  RecordableModule.swift
//  Clue
//
//  Created by Andrea Prearo on 5/22/17.
//  Copyright © 2017 Ahmed Sulaiman. All rights reserved.
//

import Foundation

/**
 `RecordableModule` protocol describe recordable module (like Video, View Structure, Network modules etc)
 which needs to track or inspect some specific information over time (like view structure for example) 
 and record this information with specific timestamp using Writers.

 @warning Every recordable module has to implement this protocol to be able to work as expected inside the system.
 */
public protocol RecordableModule {
    /// Initializes the recordable module with a specific writer which implements the `Writable` protocol.
    /// This will in turn allow the info module to record/write all required data.
    ///
    /// - Parameter writer: The Writer object which implements the `Writable` protocol.
    ///                     It will be responsible for writing the actual data to a specific file.
    init(writer: Writable)

    /// Starts the recording for current recordable module.
    /// Usually you perform the required set up here and then start the actual recording
    /// (which is specific for your recordable module).
    func startRecording()

    /// Stops the recording for the current recordable module.
    /// Usually you can perform the required cleanup here and then stop the actual recording
    /// (which is specific for your recordable module).
    func stopRecording()

    /// This method will be called by a third-party (see `ReportComposer`) when new frame with new timestamp is available.
    /// Usually your module needs to handle all the recording related operations here and set up the specific timestamp for ech new frame.
    ///
    /// - Parameter timestamp: The timestamp for the new frame.
    ///                        The underlying module will append the new frame for this timestamp, if available.
    func addNewFrame(for timestamp: TimeInterval)
}
