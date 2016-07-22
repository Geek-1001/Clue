//
//  CLURecordIndicatorView.h
//  Clue
//
//  Created by Ahmed Sulaiman on 7/22/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLURecordIndicatorView : UIView

@property (nonatomic, readonly) UIViewController *viewController;

- (instancetype)initWithViewController:(UIViewController *)viewController;
- (void)setTarget:(id)target andAction:(SEL)action;

- (void)startCountdownTimerWithMaxTime:(NSDateComponents *)maxTime;
- (void)stopCountdownTimer;

@end
