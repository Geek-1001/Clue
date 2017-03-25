//
//  CLUGeneralGestureRecognizer.h
//  Clue
//
//  Created by Ahmed Sulaiman on 6/7/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIGestureRecognizerSubclass.h>
#import "CLUInteractionObserverDelegate.h"

/**
 `CLUGeneralGestureRecognizer` is a subclass of `UIGestureRecognizer` to intercept all user gestures and interactions during report recording and redirect them to appropriate delegate method from `CLUInteractionObserverDelegate`
 */
@interface CLUGeneralGestureRecognizer : UIGestureRecognizer

/**
 Set `CLUInteractionObserverDelegate` delegate to handle gesture recognizer's events

 @param delegate Delegate instance of `CLUInteractionObserverDelegate` to be able to redirect gesture recognizer's events from `CLUGeneralGestureRecognizer` to appropriate delegate method
 
 @warning Always call `-removeObserverDelegate` when you don't need gesture recognizer delegate anymore
 */
- (void)setObserverDelegate:(id <CLUInteractionObserverDelegate>)delegate;

/**
 Remove `CLUInteractionObserverDelegate` delegate object
 */
- (void)removeObserverDelegate;

@end
