//
//  CLUUserInteractionModule.h
//  Clue
//
//  Created by Ahmed Sulaiman on 6/4/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import "CLUObserveModule.h"
#import "CLUInteractionObserverDelegate.h"

/**
 `CLUUserInteractionModule` is a subclass of `CLUObserveModule` for user interactions recording (like touches) for any specific time. It will listen for all gestures/touches via custom gesture recognizer and recognizer will send them to `CLUInteractionObserverDelegate` methods so `CLUUserInteractionModule` can add this data to buffer with specific timestamp
 */
@interface CLUUserInteractionModule : CLUObserveModule <CLUInteractionObserverDelegate>

@end
