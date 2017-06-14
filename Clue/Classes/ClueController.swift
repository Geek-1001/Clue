//
//  ClueController.swift
//  Clue
//
//  Created by Andrea Prearo on 5/22/17.
//  Copyright © 2017 Ahmed Sulaiman. All rights reserved.
//

import Foundation

/**
 `ClueController` is a singleton class and main Clue controller which is also the only 
 public interface for framework user. Here user can turn on/off Clue and start/stop report recording.
 */
public class ClueController: NSObject {
    /// Singleton instance
    public static let shared = ClueController()

    // MARK: - Private Properties
    fileprivate var recordableModules: [RecordableModule]?
    fileprivate var infoModules: [InfoModule]?
    fileprivate var isEnabled = false
    fileprivate var isRecording = false
    fileprivate var waitVideoRenderingQueue: DispatchQueue?
    fileprivate var options: CLUOptions?
    fileprivate var reportComposer: ReportComposer?
    fileprivate var mailDelegate: CLUMailDelegate?

    static let recordableModulesDirectory = CLUReportFileManager.shared().recordableModulesDirectoryURL
    static let infoModulesDirectory = CLUReportFileManager.shared().infoModulesDirectoryURL

    // Making this private because this class is a singleton.
    fileprivate override init() {
        super.init()
        recordableModules = setUpRecordableModules()
        infoModules = setUpInfoModules()
        reportComposer = ReportComposer(recordableModules: recordableModules)
        reportComposer?.setInfoModules(infoModules)
        setUpUncaughtExceptionHandler()
        waitVideoRenderingQueue = DispatchQueue(label: "ClueController.waitVideoRenderingQueue")
        mailDelegate = CLUMailDelegate()
    }

    /// Starts the actual recording.
    /// You should call this method directly only if you want to start recording with your own custom UI element.
    /// It's recommended to use the `handleShake()` instance method.
    public func startRecording() {
        guard let viewController = CLURecordIndicatorViewManager.currentViewController() else {
            return
        }
        if CLUReportFileManager.shared().isReportZipFileAvailable() {
            showAlert(title: "Send Previous Clue Report",
                      message: "Do you want to send your previous Clue Report caused by internal excpetion?",
                      successActionTitle: "Send Report", failureActionTitle: "Delete Report",
                      successHandler: { [weak self] in
                        self?.sendReportWithEmailService()
                      },
                      failureHandler: {
                        CLUReportFileManager.shared().removeReportZipFile()
                      },
                      viewController: viewController)
            return
        }

        if isRecording {
            return
        }
        isRecording = true
        reportComposer?.startRecording()

        let maxTime = CLURecordIndicatorViewManager.defaultMaxTime()
        CLURecordIndicatorViewManager.showRecordIndicator(in: viewController, withMaxTime: maxTime, target: self, andAction: #selector(stopRecording))
    }

    /// Stops the actual recording.
    /// You should call this method directly only if you want to stop recording with your own custom UI element.
    /// It's recommended to use the `handleShake()` instance method.
    public func stopRecording() {
        if !isRecording {
            return
        }
        isRecording = false
        reportComposer?.stopRecording()

        CLURecordIndicatorViewManager.switchRecordIndicatorToWaitingMode()
        // Delay before zipping report, video rendering have to end properly
        waitVideoRenderingQueue?.async {
            // TODO: come up with better approach
            Thread.sleep(forTimeInterval: 4)
            DispatchQueue.main.sync { [weak self] in
                CLURecordIndicatorViewManager.hideRecordIndicator()
                self?.sendReportWithEmailService()
            }
        }
    }

    /// Handles a shake gesture to start/stop recording.
    ///
    /// - Parameter motion: The motion event type
    public func handleShake(_ motion: UIEventSubtype) {
        guard motion == .motionShake && isEnabled else {
            // TODO: print warning message
            return
        }
        if isRecording {
            stopRecording()
        } else {
            startRecording()
        }
    }

    /// Enables the controller functionality.
    ///
    /// - Parameter options: The options to configure the recording behavior.
    public func enable(with options: CLUOptions?) {
        if !isEnabled {
            isEnabled = true
            self.options = options
        }
    }

    /// Enables the controller functionality.
    public func enable() {
        enable(with: nil)
    }

    /// Disables the controller functionality.
    public func disable() {
        if isEnabled {
            isEnabled = false
            // TODO: clear everything redundant
        }
    }
}

// MARK: - Set Up Methods
fileprivate extension ClueController {
    func setUpUncaughtExceptionHandler() {
        NSSetUncaughtExceptionHandler { exception in
            ClueController.shared.handleException(exception)
        }
    }

    // MARK: - Set Up Recordable Modules
    func setUpRecordableModules() -> [RecordableModule]? {
        let videoModule = setUpVideoModule()
        let viewStructureModule = setUpViewStructureModule()
        let userInteractionModule = setUpUserInteractionModule()
        let networkModule = setUpNetworkModule()
        let modules: [RecordableModule] = [
            videoModule,
            viewStructureModule,
            userInteractionModule,
            networkModule
        ].filter { $0 != nil }.map { $0 as! RecordableModule }
        return modules
    }

    func setUpVideoModule() -> VideoModule? {
        let viewSize = UIScreen.main.bounds.size
        let viewScale = UIScreen.main.scale
        guard let outputURL = ClueController.recordableModulesDirectory?.appendingPathComponent("module_video.mp4"),
            let videoWriter = VideoWriter(outputURL: outputURL, viewSize: viewSize, viewScale: viewScale) else {
            // TODO: handle errors
            return nil
        }
        return VideoModule(writer: videoWriter)
    }
    
    func setUpViewStructureModule() -> ViewStructureModule? {
        guard let outputURL = ClueController.recordableModulesDirectory?.appendingPathComponent("module_view.json"),
            let jsonWriter = JSONWriter(outputURL: outputURL) else {
            // TODO: handle errors
            return nil
        }
        return ViewStructureModule(writer: jsonWriter)
    }
    
    func setUpUserInteractionModule() -> UserInteractionModule? {
        guard let outputURL = ClueController.recordableModulesDirectory?.appendingPathComponent("module_interaction.json"),
            let jsonWriter = JSONWriter(outputURL: outputURL) else {
            // TODO: handle errors
            return nil
        }
        return UserInteractionModule(writer: jsonWriter)
    }
    
    func setUpNetworkModule() -> NetworkModule? {
        guard let outputURL = ClueController.recordableModulesDirectory?.appendingPathComponent("module_network.json"),
            let jsonWriter = JSONWriter(outputURL: outputURL) else {
            // TODO: handle errors
            return nil
        }
        return NetworkModule(writer: jsonWriter)
    }
    
    // MARK: - Set Up Info Modules
    func setUpInfoModules() -> [InfoModule]? {
        let deviceInfoModule = setUpDeviceInfoModule()
        let modules: [InfoModule] = [
            deviceInfoModule
        ].filter { $0 != nil }.map { $0! }
        return modules
    }

    func setUpDeviceInfoModule() -> DeviceInfoModule? {
        guard let outputURL = ClueController.infoModulesDirectory?.appendingPathComponent("info_device.json"),
            let jsonWriter = JSONWriter(outputURL: outputURL) else {
            // TODO: handle errors
            return nil
        }
        return DeviceInfoModule(writer: jsonWriter)
    }
}

// MARK: - Private Methods
fileprivate extension ClueController {
    func sendReportWithEmailService() {
        guard let viewController = CLURecordIndicatorViewManager.currentViewController(),
            let mailDelegate = mailDelegate,
            let mailHelper = CLUMailHelper(options: options) else {
            return
        }
        mailHelper.setMailDelegate(mailDelegate)
        // TODO: test it on real device. Mail isn't working on simulator
        mailHelper.showMailComposeWindow(with: viewController)
    }

    func handleException(_ exception: NSException) {
        guard isEnabled, isRecording,
            let outputURL = ClueController.infoModulesDirectory?.appendingPathComponent("info_exception.json"),
            let jsonWriter = JSONWriter(outputURL: outputURL) else {
            return
        }
        let exceptionInfoModule = ExceptionInfoModule(writer: jsonWriter, exception: exception)
        exceptionInfoModule.recordInfoData()

        waitVideoRenderingQueue?.sync {
            ClueController.shared.stopRecording()
            CLUReportFileManager.shared().createZipReportFile()
            // Crazy hack! If exception occurs wait till video writer finish async handler: `AVAssetWriter` `finishWritingWithCompletionHandler`.
            // TODO: come up with better approach
            Thread.sleep(forTimeInterval: 4)
        }
    }

    func showAlert(title: String,
                   message: String,
                   successActionTitle: String,
                   failureActionTitle: String,
                   successHandler: (() -> Void)? = nil,
                   failureHandler: (() -> Void)? = nil,
                   viewController: UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let successAction = UIAlertAction(title: successActionTitle, style: .default) { _ in
            successHandler?()
        }
        let failureAction = UIAlertAction(title: failureActionTitle, style: .default) { _ in
            failureHandler?()
        }
        alertController.addAction(successAction)
        alertController.addAction(failureAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
}
