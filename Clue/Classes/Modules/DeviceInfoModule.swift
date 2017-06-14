//
//  DeviceInfoModule.swift
//  Clue
//
//  Created by Andrea Prearo on 5/8/17.
//  Copyright © 2017 Ahmed Sulaiman. All rights reserved.
//

import Foundation

/// `DeviceInfoModule` is a info module (with static, one-time informations) for current devices' information recording on start.
public class DeviceInfoModule: NSObject, InfoModule {
    fileprivate let writer: JSONWriter

    // MARK: - Lifecycle
    public required init(writer: Writable) {
        self.writer = writer as! JSONWriter
    }

    // MARK: - Public Methods
    public func recordInfoData() {
        let deviceProperties = UIDevice.current.clueProperties()
        writer.startWriting()
        writer.append(json: deviceProperties)
        writer.finishWriting()
    }
}
