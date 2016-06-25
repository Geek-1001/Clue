//
//  UITouch+CLUUserInteractionAdditions.m
//  Clue
//
//  Created by Ahmed Sulaiman on 6/7/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import "UITouch+CLUUserInteractionAdditions.h"

@implementation UITouch (CLUUserInteractionAdditions)

- (NSDictionary *)clue_touchProperties {
    if (!self) {
        return nil;
    }
    
    CGPoint locationInWindow = [self locationInView:nil];
    NSInteger tapCount = [self tapCount];
    
    NSMutableDictionary *touchProperties = [[NSMutableDictionary alloc] init];
    [touchProperties setObject:@(tapCount) forKey:@"tapCount"];
    
    NSMutableDictionary *locationDictionary = [[NSMutableDictionary alloc] init];
    [locationDictionary setObject:@(locationInWindow.x) forKey:@"x"];
    [locationDictionary setObject:@(locationInWindow.y) forKey:@"y"];
    
    [touchProperties setObject:locationDictionary forKey:@"locationInWindow"];
    
    return touchProperties;
}

@end
