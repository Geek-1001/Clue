//
//  CLUTouchUserInteractionAdditions.m
//  Clue
//
//  Created by Ahmed Sulaiman on 3/16/17.
//  Copyright © 2017 Ahmed Sulaiman. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "UITouch+CLUUserInteractionAdditions.h"

@interface CLUTouchUserInteractionAdditions : XCTestCase

@end

@implementation CLUTouchUserInteractionAdditions

- (void)testTouchProperties {
    // Initialize test variables
    UITouch *testTouch = [UITouch new];
    NSDictionary *testTouchProperties = @{@"tapCount" : @0,
                                          @"locationInWindow" : @{
                                                  @"x" : @0,
                                                  @"y" : @0
                                                  }
                                          };
    
    // Test Touch Properties dictionary
    NSDictionary *touchProperties = [testTouch clue_touchProperties];
    XCTAssertNotNil(touchProperties, @"Touch Properties is invalis");
    XCTAssertTrue([touchProperties isEqualToDictionary:testTouchProperties], @"Touch Properties is not equal to test data");
}

@end
