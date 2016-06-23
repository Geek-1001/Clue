//
//  CLUUserInteractionModule.h
//  Clue
//
//  Created by Ahmed Sulaiman on 6/4/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import "CLUObserveModule.h"
#import "CLUInteractionObserverDelegate.h"

@interface CLUUserInteractionModule : CLUObserveModule <CLUInteractionObserverDelegate>

- (void)startRecording;
- (void)stopRecording;

@end
