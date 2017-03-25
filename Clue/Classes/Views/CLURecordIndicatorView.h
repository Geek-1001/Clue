//
//  CLURecordIndicatorView.h
//  Clue
//
//  Created by Ahmed Sulaiman on 7/22/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 `CLURecordIndicatorView` is a view object to indicate recording process to user, will appear at the top of the screen, right after statusBar
*/
@interface CLURecordIndicatorView : UIView

/**
 `UIViewController` where `CLURecordIndicatorView` will be presented
*/
@property (nonatomic, readonly) UIViewController *viewController;

/**
 Create new `CLURecordIndicatorView` instance with specific `UIViewController`
 
 @params viewController `UIViewController` where `CLURecordIndicatorView` will be presented
 
 @return `CLURecordIndicatorView` instance
*/
- (instancetype)initWithViewController:(UIViewController *)viewController;

/**
 Specify target and action which would be triggered in case of countdown timer timeout or user press on the view.
 Since we can't record report forever we have to limit recording time
 
 @param target Target object which will handle action selector
 @param action Action method selector which will handle the event
*/
- (void)setTarget:(id)target andAction:(SEL)action;

/**
 Switch `CLURecordIndicatorView` to waiting mode where user will see "Waiting..." text on the indicator.
 Used after successful record during report file writing process.
 
 @param isWaitingMode BOOL flag to indicate whether waiting mode currently enable or not
*/
- (void)setWaitingMode:(BOOL)isWaitingMode;

/**
 Start countdown timer with specific amount of time. Which will perform target and action at the timeout
 
 @param maxTime Maximum time specified in `NSDateComponents` minutes and seconds
*/
- (void)startCountdownTimerWithMaxTime:(NSDateComponents *)maxTime;

/**
 Stop immediately countdown timer and invalidate it
*/
- (void)stopCountdownTimer;

@end
