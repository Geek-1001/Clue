//
//  UserInteractionModule.swift
//  Clue
//
//  Created by Andrea Prearo on 5/8/17.
//  Copyright © 2017 Ahmed Sulaiman. All rights reserved.
//

import Foundation

let UserInteractionTouchBeganEvent = "Began"
let UserInteractionTouchMovedEvent = "Moved"
let UserInteractionTouchEndedEvent = "Ended"

/// `UserInteractionModule` is a subclass of `ObserveModule` for user interactions recording 
/// (like touches) for any specific time. It will listen for all gestures/touches via custom 
/// gesture recognizer and recognizer will send them to `CLUInteractionObserverDelegate` 
/// methods so `UserInteractionModule` can add this data to buffer with specific timestamp.
public class UserInteractionModule: ObserveModule {
    fileprivate var gestureRecognizer = CLUGeneralGestureRecognizer()
}

// MARK: - UserInteractionModule + CLURecordableModule
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
        addOneTimeTouches(touches, type: UserInteractionTouchBeganEvent)
    }

    public func touchesMoved(_ touches: [CLUTouch]) {
        addOneTimeTouches(touches, type: UserInteractionTouchMovedEvent)
    }

    public func touchesEnded(_ touches: [CLUTouch]) {
        addOneTimeTouches(touches, type: UserInteractionTouchEndedEvent)
    }
}

// MARK: - Private Methods
extension UserInteractionModule {
    func addOneTimeTouches(_ touches: [CLUTouch], type: String) {
        recordQueue?.sync {
            var touchDictionary: [AnyHashable: Any] = [
                "type": type
            ].merged(with: timestampDictionary)
            if touches.count > 0 {
                let touchesArray = touches.map { $0.properties() }
                touchDictionary["touches"] = touchesArray
            }
            addData(bufferItem: touchDictionary)
        }
    }
}
