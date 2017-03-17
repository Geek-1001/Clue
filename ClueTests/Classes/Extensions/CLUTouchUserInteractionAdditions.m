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
    
    // Test Touch Properties dictionary
    NSDictionary *touchProperties = [testTouch clue_touchProperties];
    XCTAssertNotNil(touchProperties, @"Touch Properties is invalis");
    XCTAssertEqual([touchProperties count], 2, @"Touch properties dictionary has wrong amount of items inside");
    
    // Test location in window property
    NSDictionary *locationInWindowDictionary = [touchProperties objectForKey:@"locationInWindow"];
    XCTAssertNotNil(locationInWindowDictionary, @"Location in window property dictionary is invalid");
    XCTAssertEqual([locationInWindowDictionary count], 2, @"Location in window property dictionary has wrong amount of utems inside");
    
    NSNumber *tapCount = [touchProperties objectForKey:@"tapCount"];
    XCTAssertNotNil(tapCount, @"Tap Count is invalid");
    XCTAssertEqual(tapCount.unsignedIntegerValue, testTouch.tapCount, @"Tap Count is incorrect");
}

@end
