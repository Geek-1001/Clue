//
//  CLURecordIndicatorView.m
//  Clue
//
//  Created by Ahmed Sulaiman on 7/22/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import "CLURecordIndicatorView.h"

#define CLURecordIndicatorViewMinimumPadding 6.0

@interface CLURecordIndicatorView()

@property (nonatomic) UILabel *titleLabel;
@property (nonatomic) UITapGestureRecognizer *gestureRecognizer;

@property (nonatomic) NSDateComponents *currentTime;
@property (nonatomic) NSTimer *secondsTimer;

@property (nonatomic) id target;
@property (nonatomic) SEL action;

@end

@implementation CLURecordIndicatorView

- (instancetype)initWithViewController:(UIViewController *)viewController {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _viewController = viewController;
    
    _gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userTapOnView:)];
    [self addGestureRecognizer:_gestureRecognizer];
    
    [self setBackgroundColor:[UIColor colorWithRed:251/255.0 green:105/255.0 blue:97/255.0 alpha:1]];
    
    _titleLabel = [[UILabel alloc] init];
    [_titleLabel setText:@"00:00"];
    [_titleLabel setTextColor:[UIColor whiteColor]];
    [_titleLabel setBackgroundColor:[UIColor clearColor]];
    [_titleLabel setFont:[UIFont systemFontOfSize:14]];
    _titleLabel.numberOfLines = 0;
    _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self addSubview:_titleLabel];
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = CGRectGetWidth(screenBounds);
    CGFloat padding = [self padding];
    CGRect titleLabelContentRect = [_titleLabel.text
                                    boundingRectWithSize:_titleLabel.frame.size
                                    options:NSStringDrawingUsesLineFragmentOrigin
                                    attributes:@{NSFontAttributeName:_titleLabel.font}
                                    context:nil];
    CGFloat titleLabelLeftTopPosition = screenWidth/2.0 - titleLabelContentRect.size.width/2.0;
    _titleLabel.frame = CGRectMake(titleLabelLeftTopPosition,
                                   padding,
                                   titleLabelContentRect.size.width,
                                   0.0);
    [_titleLabel sizeToFit];
    
    CGFloat actualHeight = padding + titleLabelContentRect.size.height + padding;
    CGFloat topPosition = -actualHeight;
    
    self.frame = CGRectMake(0.0, topPosition, screenWidth, actualHeight);
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    
    return self;
}

- (CGFloat)padding {
    return CLURecordIndicatorViewMinimumPadding;
}

- (void)setTarget:(id)target andAction:(SEL)action {
    if (target && action) {
        _target = target;
        _action = action;
    }
}

- (void)startCountdownTimerWithMaxTime:(NSDateComponents *)maxTime {
    _currentTime = maxTime;
    _secondsTimer = [NSTimer scheduledTimerWithTimeInterval:1
                                                     target:self
                                                   selector:@selector(timerTickTock)
                                                   userInfo:nil
                                                    repeats:YES];
    
    NSUInteger stopTimerDelay = (maxTime.minute * 60) + maxTime.second;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, stopTimerDelay * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [self stopCountdownTimer];
    });
}

- (void)stopCountdownTimer {
    if (_secondsTimer) {
        [_secondsTimer invalidate];
        _secondsTimer = nil;
        _currentTime = nil;
    }
}

- (void)userTapOnView:(UITapGestureRecognizer *)gestureRecognizer {
    [self stopCountdownTimer];
    if (_target && _action) {
        IMP imp = [_target methodForSelector:_action];
        void (*func)(id, SEL) = (void *)imp;
        func(_target, _action);
    }
}

- (void)timerTickTock {
    if (_currentTime) {
        return;
    }
    
    _currentTime.second = _currentTime.second - 1;
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *date = [gregorianCalendar dateFromComponents:_currentTime];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"mm:ss";
    _titleLabel.text = [formatter stringFromDate:date];
}

@end
