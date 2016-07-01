//
//  CLUTouch.h
//  Clue
//
//  Created by Ahmed Sulaiman on 7/1/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CLUTouch : NSObject

@property (nonatomic, readonly) CGPoint locationInWindow;
@property (nonatomic, readonly) NSInteger tapCount;

- (instancetype)initWithTouch:(UITouch *)touch;
- (NSDictionary *)properties;

@end
