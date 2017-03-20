//
//  CLUTouchTests.m
//  Clue
//
//  Created by Ahmed Sulaiman on 3/20/17.
//  Copyright © 2017 Ahmed Sulaiman. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CLUTouch.h"

@interface CLUTouchTests : XCTestCase
@property (nonatomic) UITouch *testTouch;
@end

@interface UITouch (Testable)
@property NSInteger tapCount;
- (instancetype)initWithTapCount:(NSInteger)tapCount;
@end

@implementation CLUTouchTests

- (void)setUp {
    [super setUp];
    _testTouch = [[UITouch alloc] initWithTapCount:2];
}

- (void)tearDown {
    _testTouch = nil;
    [super tearDown];
}

- (void)testInitWithTouch {
    // Create CLUTouch object from UITouch object
    CLUTouch *touch = [[CLUTouch alloc] initWithTouch:_testTouch];
    XCTAssertNotNil(touch, @"CLU Touch object is invalid");
    XCTAssertEqual(touch.tapCount, _testTouch.tapCount, @"CLU Touch object has incorect tapCount");
    XCTAssertEqual(touch.locationInWindow.x, [_testTouch locationInView:nil].x, @"CLU Touch object has incorect locationInWindow X coordinate");
    XCTAssertEqual(touch.locationInWindow.y, [_testTouch locationInView:nil].y, @"CLU Touch object has incorect locationInWindow Y coordinate");
}

- (void)testProperties {
    // Initialize test variables
    NSDictionary *testTouchDictionary = @{@"tapCount" : @(2),
                                          @"locationInWindow" : @{
                                                  @"x" : @(0),
                                                  @"y" : @(0)
                                                  }
                                          };
    
    // Test CLU Touch object initialization
    CLUTouch *touch = [[CLUTouch alloc] initWithTouch:_testTouch];
    XCTAssertNotNil(touch, @"CLU Touch object is invalid");
    
    // Test touch properties dictionary
    NSDictionary *touchDictionary = [touch properties];
    XCTAssertNotNil(touchDictionary, @"Touch Dictionary is invalid");
    XCTAssertTrue([touchDictionary isEqualToDictionary:testTouchDictionary], @"Touch Dictionary is incorrect");
}

@end

@implementation UITouch (Testable)

@dynamic tapCount;

- (instancetype)initWithTapCount:(NSInteger)tapCount {
    self = [super init];
    if (self == nil) {
        return nil;
    }
    self.tapCount = tapCount;
    return self;
}

@end
