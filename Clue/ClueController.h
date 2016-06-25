//
//  Clue.h
//  Clue
//
//  Created by Ahmed Sulaiman on 5/11/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLUOptions.h"

@interface ClueController : NSObject

+ (instancetype)sharedInstance;
- (void)startRecording;
- (void)stopRecording;
- (void)handleShake:(UIEventSubtype)motion;

- (void)enable;
- (void)disable;
- (void)enableWithOptions:(CLUOptions *)options;

@end
