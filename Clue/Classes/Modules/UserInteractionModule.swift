//
//  UserInteractionModule.swift
//  Clue
//
//  Created by Andrea Prearo on 5/8/17.
//  Copyright © 2017 Ahmed Sulaiman. All rights reserved.
//

import Foundation

/// `UserInteractionModule` is a subclass of `ObserveModule` for user interactions recording
/// (like touches) for any specific time. It will listen for all gestures/touches via custom 
/// gesture recognizer and recognizer will send them to `CLUInteractionObserverDelegate` 
/// methods so `UserInteractionModule` can add this data to buffer with specific timestamp.
public class UserInteractionModule: ObserveModule {
    enum UserInteractionEventType: String {
        case began = "Began"
        case moved = "Moved"
        case ended = "Ended"
    }

    fileprivate var gestureRecognizer = CLUGeneralGestureRecognizer()
}

// MARK: - UserInteractionModule + RecordableModule
extension UserInteractionModule {
    override public func startRecording() {
        if !isRecording {
            super.startRecording()
            gestureRecognizer.setObserverDelegate(self)
            // FIXME: If some window will be destroyed how to deattach gesture recognizer from it? Possible memory leak!
            UIApplication.shared.keyWindow?.addGestureRecognizer(gestureRecognizer)
        }
    }
    
    override public func stopRecording() {
        if isRecording {
            super.stopRecording()
            UIApplication.shared.keyWindow?.removeGestureRecognizer(gestureRecognizer)
            gestureRecognizer.removeObserverDelegate()
        }
    }
}

// MARK: - UserInteractionModule + CLUInteractionObserverDelegate
extension UserInteractionModule: CLUInteractionObserverDelegate {
    public func touchesBegan(_ touches: [CLUTouch]) {
        addOneTimeTouches(touches, type: UserInteractionEventType.began)
    }

    public func touchesMoved(_ touches: [CLUTouch]) {
        addOneTimeTouches(touches, type: UserInteractionEventType.moved)
    }

    public func touchesEnded(_ touches: [CLUTouch]) {
        addOneTimeTouches(touches, type: UserInteractionEventType.ended)
    }
}

// MARK: - Private Methods
extension UserInteractionModule {
    func addOneTimeTouches(_ touches: [CLUTouch], type: UserInteractionEventType) {
        recordQueue?.sync {
            var touchDictionary: [AnyHashable: Any] = [
                "type": type.rawValue
            ].merged(with: timestampDictionary)
            if touches.count > 0 {
                let touchesArray = touches.map { $0.properties() }
                touchDictionary["touches"] = touchesArray
            }
            addData(bufferItem: touchDictionary)
        }
    }
}
