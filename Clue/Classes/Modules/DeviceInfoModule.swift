//
//  DeviceInfoModule.swift
//  Clue
//
//  Created by Andrea Prearo on 5/8/17.
//  Copyright © 2017 Ahmed Sulaiman. All rights reserved.
//

import Foundation

/// `DeviceInfoModule` is a info module (with static, one-time informations) for current devices' information recording on start.
public class DeviceInfoModule: NSObject, CLUInfoModule {
    fileprivate let writer: JSONWriter

    // MARK: - Lifecycle
    public required init(writer: CLUWritable) {
        self.writer = writer as! JSONWriter
    }

    // MARK: - Public Methods
    public func recordInfoData() {
        let deviceProperties = getDeviceProperties()
        writer.startWriting()
        writer.append(json: deviceProperties)
        writer.finishWriting()
    }
}

// MARK: - Private Methods
fileprivate extension DeviceInfoModule {
    func getDeviceProperties() -> [AnyHashable: Any] {
        let device = UIDevice.current
        var deviceProperties: [AnyHashable: Any] = [
            "name": device.name,
            "systemName": device.systemName,
            "systemVersion": device.systemVersion,
            "model": device.model,
            "batteryLevel": device.batteryLevel,
            "batteryState": device.batteryState.rawValue
        ]
        if let identifierForVendor = device.identifierForVendor?.uuidString {
            deviceProperties["identifierForVendor"] = identifierForVendor
        }
        return deviceProperties
    }
}
