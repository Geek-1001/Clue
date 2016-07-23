//
//  CLURecordIndicatorViewManager.m
//  Clue
//
//  Created by Ahmed Sulaiman on 7/22/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import "CLURecordIndicatorViewManager.h"
#import "CLURecordIndicatorView.h"

@interface CLURecordIndicatorViewManager()

@property (nonatomic) CLURecordIndicatorView *indicatorView;

+ (instancetype)sharedManager;
- (void)showRecordIndicatorView:(CLURecordIndicatorView *)indicatorView;
- (void)hideRecordIndicatorView:(CLURecordIndicatorView *)indicatorView;
- (BOOL)isNavigationBarHiddenForNavigationController:(UINavigationController *)navigationController;

@end

@implementation CLURecordIndicatorViewManager

#pragma mark - Public methods

+ (void)showRecordIndicatorInViewController:(UIViewController *)viewController
                                withMaxTime:(NSDateComponents *)maxTime
                                     target:(id)target
                                  andAction:(SEL)action {
    if (!viewController || !maxTime) {
        return;
    }
    CLURecordIndicatorView *indicatorView = [[CLURecordIndicatorView alloc] initWithViewController:viewController];
    [indicatorView setTarget:target andAction:action];
    
    CLURecordIndicatorViewManager *viewManager = [CLURecordIndicatorViewManager sharedManager];
    viewManager.indicatorView = indicatorView;
    [viewManager showRecordIndicatorView:indicatorView];
    [indicatorView startCountdownTimerWithMaxTime:maxTime];
}

+ (void)hideRecordIndicator {
    CLURecordIndicatorViewManager *viewManager = [CLURecordIndicatorViewManager sharedManager];
    CLURecordIndicatorView *indicatorView = viewManager.indicatorView;
    if (indicatorView) {
        [viewManager hideRecordIndicatorView:indicatorView];
        [indicatorView stopCountdownTimer];
        viewManager.indicatorView = nil;
    }
}

+ (UIViewController *)currentViewController {
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    if (!keyWindow) {
        return nil;
    }
    UIViewController *rootViewController = [keyWindow rootViewController];
    if (!rootViewController) {
        return nil;
    }
    return [[self sharedManager] topViewControllerWithRootViewController:rootViewController];
}

+ (NSDateComponents *)defaultMaxTime {
    NSDateComponents *maxTimeComponent = [[NSDateComponents alloc] init];
    maxTimeComponent.minute = 3;
    maxTimeComponent.second = 0;
    return maxTimeComponent;
}

#pragma mark Initialization

+ (instancetype)sharedManager {
    static CLURecordIndicatorViewManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

#pragma mark Private view appearence methods

- (void)showRecordIndicatorView:(CLURecordIndicatorView *)indicatorView {
    CGFloat verticalOffset = 0.0f;
    UINavigationController *currentNavigationController;
    
    if ([indicatorView.viewController isKindOfClass:[UINavigationController class]]) {
        currentNavigationController = (UINavigationController *)indicatorView.viewController;
    } else if ([indicatorView.viewController.parentViewController isKindOfClass:[UINavigationController class]]) {
        currentNavigationController = (UINavigationController *)indicatorView.viewController.parentViewController;
    }
    
    if (currentNavigationController) {
        if (![self isNavigationBarHiddenForNavigationController:currentNavigationController]) {
            [currentNavigationController.view insertSubview:indicatorView
                                               belowSubview:[currentNavigationController navigationBar]];
            verticalOffset = [currentNavigationController navigationBar].bounds.size.height;
        } else {
            [indicatorView.viewController.view addSubview:indicatorView];
        }
    } else {
        [indicatorView.viewController.view addSubview:indicatorView];
    }
    
    CGSize statusBarSize = [UIApplication sharedApplication].statusBarFrame.size;
    verticalOffset += statusBarSize.height;
    CGPoint toPoint = CGPointMake(indicatorView.center.x, verticalOffset + CGRectGetHeight(indicatorView.frame) / 2.0);
    dispatch_block_t animationBlock = ^{
        indicatorView.center = toPoint;
    };
    
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState
                     animations:animationBlock
                     completion:nil];
}

- (void)hideRecordIndicatorView:(CLURecordIndicatorView *)indicatorView {
    CGPoint hideToPoint = CGPointMake(indicatorView.center.x, -CGRectGetHeight(indicatorView.frame)/2.f);
    dispatch_block_t animationBlock = ^{
        indicatorView.center = hideToPoint;
        indicatorView.alpha = 0.f;
    };
    void(^completionBlock)(BOOL) = ^(BOOL finished) {
        [indicatorView removeFromSuperview];
    };
    
    [UIView animateWithDuration:0.3
                     animations:animationBlock
                     completion:completionBlock];
}

- (BOOL)isNavigationBarHiddenForNavigationController:(UINavigationController *)navigationController {
    if ([navigationController isNavigationBarHidden]) {
        return YES;
    } else if ([[navigationController navigationBar] isHidden]) {
        return YES;
    } else {
        return NO;
    }
}

- (UIViewController *)topViewControllerWithRootViewController:(UIViewController *)rootViewController {
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarController = (UITabBarController *) rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *) rootViewController;
        return [self topViewControllerWithRootViewController:navigationController.topViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController *presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    } else {
        return rootViewController;
    }
}

@end
