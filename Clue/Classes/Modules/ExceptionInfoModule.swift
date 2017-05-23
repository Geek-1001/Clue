//
//  ExceptionInfoModule.swift
//  Clue
//
//  Created by Andrea Prearo on 5/8/17.
//  Copyright © 2017 Ahmed Sulaiman. All rights reserved.
//

import Foundation

/// `ExceptionInfoModule` is a info module (with static, one-time informations) for 
/// unexpected exception recording if occurred.
public class ExceptionInfoModule: NSObject, InfoModule {
    var exception: NSException?

    // MARK: - Private Properties
    fileprivate let writer: JSONWriter

    // MARK: - Lifecycle
    public required init(writer: Writable) {
        self.writer = writer as! JSONWriter
    }

    public convenience init(writer: Writable, exception: NSException) {
        self.init(writer: writer)
        self.exception = exception
    }

    // MARK: - Public Methods
    public func recordInfoData() {
        let exceptionProperties: [AnyHashable: Any] = {
            guard let exception = exception,
                let properties = exception.clue_exceptionProperties() else {
                return [:]
            }
           return properties
        }()
        writer.startWriting()
        writer.append(json: exceptionProperties)
        writer.finishWriting()
    }
}
