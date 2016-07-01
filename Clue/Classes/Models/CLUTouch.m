//
//  CLUTouch.m
//  Clue
//
//  Created by Ahmed Sulaiman on 7/1/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import "CLUTouch.h"

@implementation CLUTouch

- (instancetype)initWithTouch:(UITouch *)touch {
    self = [super init];
    if (!self || !touch) {
        return nil;
    }
    CGPoint locationInWindow = [touch locationInView:nil];
    NSInteger tapCount = [touch tapCount];
    _locationInWindow = locationInWindow;
    _tapCount = tapCount;
    
    return self;
}

- (NSDictionary *)properties {
    NSMutableDictionary *touchProperties = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *locationDictionary = [[NSMutableDictionary alloc] init];
    
    [touchProperties setObject:@(_tapCount) forKey:@"tapCount"];
    [locationDictionary setObject:@(_locationInWindow.x) forKey:@"x"];
    [locationDictionary setObject:@(_locationInWindow.y) forKey:@"y"];
    [touchProperties setObject:locationDictionary forKey:@"locationInWindow"];
    
    return touchProperties;
}

@end
