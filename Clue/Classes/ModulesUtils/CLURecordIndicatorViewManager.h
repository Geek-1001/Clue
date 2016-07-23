//
//  CLURecordIndicatorViewManager.h
//  Clue
//
//  Created by Ahmed Sulaiman on 7/22/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CLURecordIndicatorViewManager : NSObject

+ (void)showRecordIndicatorInViewController:(UIViewController *)viewController
                                withMaxTime:(NSDateComponents *)maxTime
                                     target:(id)target
                                  andAction:(SEL)action;
+ (void)hideRecordIndicator;

+ (UIViewController *)currentViewController;
+ (NSDateComponents *)defaultMaxTime;

@end
