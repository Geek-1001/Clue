//
//  CLUTouchTests.m
//  Clue
//
//  Created by Ahmed Sulaiman on 3/20/17.
//  Copyright © 2017 Ahmed Sulaiman. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CLUTouch.h"
#import <OCHamcrestIOS/OCHamcrestIOS.h>
#import <OCMockitoIOS/OCMockitoIOS.h>

@interface CLUTouchTests : XCTestCase
@property (nonatomic) UITouch *testTouch;
@end

@implementation CLUTouchTests

- (void)setUp {
    [super setUp];
    _testTouch = mock([UITouch class]);
    [given([_testTouch tapCount]) willReturn:@2];
    CGPoint testLocationInWindow = CGPointMake(10, 5);
    [given([_testTouch locationInView:nil]) willReturnStruct:&testLocationInWindow
                                                    objCType:@encode(CGPoint)];
}

- (void)tearDown {
    _testTouch = nil;
    [super tearDown];
}

- (void)testInitWithTouch {
    // Create CLUTouch object from UITouch object
    CLUTouch *touch = [[CLUTouch alloc] initWithTouch:_testTouch];
    XCTAssertNotNil(touch, @"CLU Touch object is invalid");
    XCTAssertEqual(touch.tapCount, 2, @"CLU Touch object has incorect tapCount");
    XCTAssertEqual(touch.locationInWindow.x, 10,
                   @"CLU Touch object has incorect locationInWindow X coordinate");
    XCTAssertEqual(touch.locationInWindow.y, 5,
                   @"CLU Touch object has incorect locationInWindow Y coordinate");
}

- (void)testProperties {
    // Initialize test variables
    NSDictionary *testTouchDictionary = @{@"tapCount" : @(2),
                                          @"locationInWindow" : @{
                                                  @"x" : @(10),
                                                  @"y" : @(5)
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
