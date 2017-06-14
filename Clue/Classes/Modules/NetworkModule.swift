//
//  NetworkModule.swift
//  Clue
//
//  Created by Andrea Prearo on 5/7/17.
//  Copyright © 2017 Ahmed Sulaiman. All rights reserved.
//

import Foundation

/// `NetworkModule` is a subclass of `ObserveModule` for network operations recording 
/// (like responses, requests and errors) for any specific time. It will listen for all 
/// network operations via custom `NSURLProtocol` subclass (see `CLUURLProtocol`) and 
/// `CLUURLProtocol` will send them to `CLUNetworkObserverDelegate` methods so 
/// `NetworkModule` can add this data to buffer with specific timestamp.
public class NetworkModule: ObserveModule {}

// MARK: - NetworkModule + RecordableModule
extension NetworkModule {
    override public func startRecording() {
        if !isRecording {
            super.startRecording()
            URLProtocol.registerClass(CLUURLProtocol.self)
            CLUURLProtocolConfiguration.shared().setNetworkObserverDelegate(self)
        }
    }
    
    override public func stopRecording() {
        if isRecording {
            super.stopRecording()
            URLProtocol.unregisterClass(CLUURLProtocol.self)
            CLUURLProtocolConfiguration.shared().removeNetworkObserverDelegate()
        }
    }
}

// MARK: - NetworkModule + CLUNetworkObserverDelegate
extension NetworkModule: CLUNetworkObserverDelegate {
    public func networkRequestDidCompleteWithError(_ error: Error?) {
        let errorProperties: [AnyHashable: Any] = {
            guard let error = error as NSError? else {
                return [:]
            }
            return error.clue_errorProperties()
        }()
        addNetworkOperationToBufferWith(label: "DidComplete", properties: [errorProperties])
    }

    public func networkRequestDidRedirect(with response: HTTPURLResponse, newRequest request: URLRequest) {
        let responseProperties = response.clue_responseProperties() ?? [:]
        let newRequestProperties = (request as NSURLRequest).clue_requestProperties() ?? [:]
        addNetworkOperationToBufferWith(label: "DidRedirect", properties: [responseProperties, newRequestProperties])
    }

    public func networkRequestDidReceive(_ data: Data) {
        // TODO: think about better approach for NSData
        let dataProperties = NSMutableDictionary()
        let bodyString = String(data: data, encoding: .utf8)
        dataProperties.clue_setValidObject(bodyString, forKey: "HTTPBody")
        guard let properties = dataProperties as? [AnyHashable: Any]  else {
            addNetworkOperationToBufferWith(label: "DidReceiveData", properties: [])
            return
        }
        addNetworkOperationToBufferWith(label: "DidReceiveData", properties: [properties])
    }

    public func networkRequestDidReceive(_ response: URLResponse) {
        let responseProperties = response.clue_responseProperties() ?? [:]
        addNetworkOperationToBufferWith(label: "DidReceiveResponse", properties: [responseProperties])
    }
}

// MARK: - Private Methods
fileprivate extension NetworkModule {
    func addNetworkOperationToBufferWith(label: String, properties: [[AnyHashable: Any]]) {
        recordQueue?.sync {
            let networkProperties: [AnyHashable: Any] = [
                "label": label,
                "properties": properties
            ].merged(with: timestampDictionary)
            addData(bufferItem: networkProperties)
        }
    }
}
