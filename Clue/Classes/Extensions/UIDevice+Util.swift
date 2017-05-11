//
//  UIDevice+Util.swift
//  Clue
//
//  Created by Andrea Prearo on 5/11/17.
//  Copyright © 2017 Ahmed Sulaiman. All rights reserved.
//

import Foundation

extension UIDevice {
    /// Returns a dictionary with the properties required to identify the device characteristics.
    ///
    /// - Returns: A dictionary with the properties required to identify the device characteristics.
    func clueProperties() -> [AnyHashable: Any] {
        var deviceProperties: [AnyHashable: Any] = [
            "name": name,
            "systemName": systemName,
            "systemVersion": systemVersion,
            "model": model,
            "batteryLevel": batteryLevel,
            "batteryState": batteryState.rawValue
        ]
        if let identifierForVendor = identifierForVendor?.uuidString {
            deviceProperties["identifierForVendor"] = identifierForVendor
        }
        return deviceProperties
    }
}
