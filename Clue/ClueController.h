//
//  Clue.h
//  Clue
//
//  Created by Ahmed Sulaiman on 5/11/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLUOptions.h"

/**
 `ClueController` is a singleton class and main Clue controller which is also the only public interface for framework user. Here user can turn on/off Clue and start/stop report recording.
 */
@interface ClueController : NSObject

/**
 Returns the shared singleton instance of `ClueController`

 @return Shared singleton instance of `ClueController`
 */
+ (instancetype)sharedInstance;

/**
 Start actual recording.
 You should call this method directly only if you want to start recording with your own custom UI element.
 It's recommended to use `[ClueController handleShake:]`
 */
- (void)startRecording;

/**
 Stop actual recording.
 You should call this method directly only if you want to stop recording with your own custom UI element.
 It's recommended to use `[ClueController handleShake:]`
 */
- (void)stopRecording;

/**
 Handle shake gesture. Which will start recording if it's stopped or stop it if it's recording now

 @param motion `UIEventSubtype` motion. This method will activate only with `UIEventSubtypeMotionShake` events
 */
- (void)handleShake:(UIEventSubtype)motion;

/**
 Enable Clue. Recording will start only with enabled Clue
 */
- (void)enable;

/**
 Disable Clue. Clue won't start recording if it's disabled.
 */
- (void)disable;

/**
 Enable Clue with `CLUOptions` options (like receiver's email). Recording will start only with enabled Clue
 
 @param options `CLUOptions` options object which contains configuration properties
 */
- (void)enableWithOptions:(CLUOptions *)options;

@end
