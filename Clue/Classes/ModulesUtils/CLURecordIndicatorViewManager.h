//
//  CLURecordIndicatorViewManager.h
//  Clue
//
//  Created by Ahmed Sulaiman on 7/22/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 `CLURecordIndicatorViewManager` is a class which show `CLURecordIndicatorView` view object for specific amount of time, hide it and switch modes of `CLURecordIndicatorView`. Also return useful view related information like current top view controller in stack.
 */
@interface CLURecordIndicatorViewManager : NSObject

/**
 Show `CLURecordIndicatorView` view object with animation in specific `UIViewController`, with target and action for specific amount of time. After time has passed - target & action get triggered.
 
 @param viewController `UIViewController` where you want to show recording indicator
 @param maxTime Maximum time `CLURecordIndicatorView` view will be visible on selected view controller. `NSDateComponents` object with specified minutes and seconds.
 @param target Target object which will handle action selector
 @param action Action method selector which will handle the event when `CLURecordIndicatorView` clicked or `maxTime` is over.
 */
+ (void)showRecordIndicatorInViewController:(UIViewController *)viewController
                                withMaxTime:(NSDateComponents *)maxTime
                                     target:(id)target
                                  andAction:(SEL)action;

/**
 Switch `CLURecordIndicatorView` to waiting mode where user will see "Waiting..." text on the indicator.
 Used after successful record during report file writing process.
 */
+ (void)switchRecordIndicatorToWaitingMode;

/**
 Hide `CLURecordIndicatorView` view from selected view controller
 */
+ (void)hideRecordIndicator;

/**
 Get current `UIViewController` which is on top of view controller's stack if there is some available.
 
 @return Current top `UIViewController` object. Derived from `UIApplication.keyWindow` and `NSWindow.rootViewController` property of this window. If `UIApplication.keyWindow` and `NSWindow.rootViewController` unavailable method returns nil
 */
+ (UIViewController *)currentViewController;

/**
 Get default maximum time for `CLURecordIndicatorView` view. It's also default time for report recording.
 
 @return Default maxTime `NSDateComponents` object. Which is equal to 3 minutes.
 */
+ (NSDateComponents *)defaultMaxTime;

@end
