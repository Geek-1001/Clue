//
//  ViewStructureModule.swift
//  Clue
//
//  Created by Andrea Prearo on 5/7/17.
//  Copyright © 2017 Ahmed Sulaiman. All rights reserved.
//

import Foundation

/// `ViewStructureModule` is a subclass of `ObserveModule` for view hierarchy recording for
/// any specific time. It will record all views currently present on the top view controller 
/// (properties of those views and their subviews as well). Also `ViewStructureModule` keep 
/// track of last recorded view structure so it won't record same view structure twice.
public class ViewStructureModule: ObserveModule {
    fileprivate var lastRecordedViewStructure: [AnyHashable: Any]? = [:]

    // MARK: - Override RecordableModule
    override public func addNewFrame(for timestamp: TimeInterval) {
        recordQueue?.sync {
            let currentViewStructure: [AnyHashable: Any]? = {
                guard let view = CLURecordIndicatorViewManager.currentViewController().view,
                    let viewStructure = view.clue_viewPropertiesDictionary() as? [AnyHashable: Any] else {
                    return nil
                }
                return viewStructure
            }()
            if let lastRecordedViewStructure = lastRecordedViewStructure as NSDictionary?,
                let currentViewStructureDict = currentViewStructure as NSDictionary?,
                lastRecordedViewStructure != currentViewStructureDict {
                self.lastRecordedViewStructure = currentViewStructure
                addViewStructureProperties(self.lastRecordedViewStructure, timestamp: timestamp)
            }
            super.addNewFrame(for: timestamp)
        }
    }
}

// MARK: - Private Methods
fileprivate extension ViewStructureModule {
    func addViewStructureProperties(_ properties: [AnyHashable: Any]?, timestamp: TimeInterval) {
        guard let properties = properties else {
            return
        }
        currentTimestamp = timestamp
        let rootViewDictionary: [AnyHashable: Any] = [
            "view": properties
        ].merged(with: timestampDictionary)
        addData(bufferItem: rootViewDictionary)
    }
}
