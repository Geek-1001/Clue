//
//  ReportComposer.swift
//  Clue
//
//  Created by Andrea Prearo on 5/22/17.
//  Copyright © 2017 Ahmed Sulaiman. All rights reserved.
//

import Foundation

public class ReportComposer: NSObject {
    // MARK: - Private Properties
    fileprivate var recordableModules: [RecordableModule]?
    fileprivate var infoModules: [InfoModule]?
    fileprivate var mainRecordQueue: DispatchQueue?
    fileprivate var moduleRecordQueue: DispatchQueue?
    fileprivate var recordSemaphore: DispatchSemaphore?
    fileprivate var displayLink: CADisplayLink?
    fileprivate var firstTimestamp: TimeInterval?

    fileprivate(set) public var isRecording = false

    /// Initializes a new `ReportComposer` instance with recordable modules array.
    /// Recording works even without info modules. But having at least one recordable module is required.
    ///
    /// - Parameter recordableModules: The recordable modules array. Each items of the array will record its own data,
    ///                      during the recording, and add the specific timestamp for each new entry.
    public init(recordableModules: [RecordableModule]?) {
        super.init()
        isRecording = false
        displayLink = CADisplayLink.init(target: self, selector: #selector(onScreenUpdate))
        self.recordableModules = recordableModules

        moduleRecordQueue = DispatchQueue(label: "ReportComposer.moduleRecordQueue")
        mainRecordQueue = DispatchQueue(label: "ReportComposer.mainRecordQueue",
                                        qos: .default, attributes: .concurrent,
                                        autoreleaseFrequency: .inherit,
                                        target: DispatchQueue.global())
        recordSemaphore = DispatchSemaphore(value: 1)
    }

    /// Initializes a new `ReportComposer` instance with recordable modules array.
    public convenience override init() {
        self.init(recordableModules: [])
    }

    /// Sets the info modules array to be used once during recording.
    /// Needs to be set up before startic the actual recording.
    ///
    /// - Parameter infoModules: The info modules array which will record the required data
    public func setInfoModules(_ infoModules: [InfoModule]?) {
        if !isRecording {
            self.infoModules = infoModules
        }
    }

    /// Starts the recording for each module (RecordableModule and InfoModule).
    public func startRecording() {
        if !isRecording {
            isRecording = true
            CLUReportFileManager.shared().createReportFile()

            if let infoModules = infoModules {
                for module in infoModules {
                    module.recordInfoData()
                }
            }

            if let recordableModules = recordableModules {
                for module in recordableModules {
                    module.startRecording()
                }
            }

            displayLink?.add(to: RunLoop.main, forMode: .commonModes)
        }
    }

    /// Stops the recording.
    public func stopRecording() {
        if isRecording {
            isRecording = false

            if let recordableModules = recordableModules {
                for module in recordableModules {
                    module.stopRecording()
                }
            }

            displayLink?.remove(from: RunLoop.main, forMode: .commonModes)
        }
    }
}

// MARK: - Private Methods
fileprivate extension ReportComposer {
    @objc func onScreenUpdate() {
        if recordSemaphore?.wait(timeout: DispatchTime.now()) != .success {
            return
        }

        mainRecordQueue?.async { [weak self] in
            guard let strongSelf = self else {
                return
            }
            if let recordableModules = strongSelf.recordableModules {
                for module in recordableModules {
                    strongSelf.moduleRecordQueue?.async {
                        if strongSelf.firstTimestamp == nil {
                            strongSelf.firstTimestamp = strongSelf.displayLink?.timestamp
                        }
                        if let timestamp = strongSelf.displayLink?.timestamp,
                            let firstTimestamp = strongSelf.firstTimestamp {
                            let elapsedTimeInterval = timestamp - firstTimestamp
                            module.addNewFrame(for: elapsedTimeInterval)
                        }
                    }
                }
            }

            strongSelf.recordSemaphore?.signal()
        }
    }
}
