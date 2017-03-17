//
//  CLUGeneralGestureRecognizerTests.m
//  Clue
//
//  Created by Ahmed Sulaiman on 3/11/17.
//  Copyright © 2017 Ahmed Sulaiman. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CLUGeneralGestureRecognizer.h"

@interface CLUTestUserInteractionObserver : NSObject <CLUInteractionObserverDelegate>
typedef NS_ENUM(NSInteger, CLUTestUserInteractionObserverEventType) {
    CLUTestUserInteractionTouchBegan,
    CLUTestUserInteractionTouchMoved,
    CLUTestUserInteractionTouchEnded
};
@property (nonatomic) NSArray<CLUTouch *> *currentTouches;
@property (nonatomic) NSArray<CLUTouch *> *currentMovedTouchesBuffer;
@property (nonatomic) CLUTestUserInteractionObserverEventType currentEventType;
@end

@interface CLUGeneralGestureRecognizerTests : XCTestCase
@property (nonatomic) CLUTestUserInteractionObserver *testUserInteractionObserver;
@property (nonatomic) CLUGeneralGestureRecognizer *gestureRecognizer;
@property (nonatomic) UIView *testView;
@property (nonatomic) UITouch *testTouch;
@property (nonatomic) UITouch *testNextTouch;
@property (nonatomic) UIEvent *testEvent;
@end

@implementation CLUGeneralGestureRecognizerTests

- (void)setUp {
    [super setUp];
    _testView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    _testUserInteractionObserver = [[CLUTestUserInteractionObserver alloc] init];
    _testTouch = [[UITouch alloc] init];
    _testNextTouch = [[UITouch alloc] init];
    _testEvent = [[UIEvent alloc] init];
    
    _gestureRecognizer = [[CLUGeneralGestureRecognizer alloc] init];
    [_gestureRecognizer setObserverDelegate:_testUserInteractionObserver];
}

- (void)tearDown {
    [_gestureRecognizer removeObserverDelegate];
    _testTouch = nil;
    _testNextTouch = nil;
    _testEvent = nil;
    [super tearDown];
}

- (void)testGestureRecognizerAttachToView {
    // Tests Attach Gesture Recognizer to Test View
    [_testView addGestureRecognizer:_gestureRecognizer];
    XCTAssertEqual([_testView.gestureRecognizers count], 1, @"Undefined gesture recognizer attached to Test View");
    XCTAssertEqual(_gestureRecognizer.view, _testView, @"Gesture recognizer attached to wrong view");
    
    // Tests Dettach Gesture Recognizer from Test View
    [_testView removeGestureRecognizer:_gestureRecognizer];
    XCTAssertEqual([_testView.gestureRecognizers count], 0, @"Gesture recognizer didn't dettached from Test View");
    XCTAssertNil(_gestureRecognizer.view, @"gesture Recognizer still has reference to view");
}

- (void)testTouchBegun {
    // Check if Gesture Recognizer enabled
    XCTAssertTrue(_gestureRecognizer.enabled, @"Gesture Recognizer is not enabled");
    
    // Test Touch Began event
    [_gestureRecognizer touchesBegan:[NSSet setWithObject:_testTouch] withEvent:_testEvent];
    XCTAssertNotNil(_testUserInteractionObserver.currentTouches, @"Current touches are invalid (touch began)");
    XCTAssertEqual([_testUserInteractionObserver.currentTouches count], 1, @"Wrong amount of touches were found (touch began)");
    XCTAssertEqual(_testUserInteractionObserver.currentEventType, CLUTestUserInteractionTouchBegan, @"Wrong touch type (touch began)");
}

- (void)testTouchEnded {
    // Check if Gesture Recognizer enabled
    XCTAssertTrue(_gestureRecognizer.enabled, @"Gesture Recognizer is not enabled");
    
    // Test Touch Ended event
    [_gestureRecognizer touchesEnded:[NSSet setWithObject:_testTouch] withEvent:_testEvent];
    XCTAssertEqual([_testUserInteractionObserver.currentTouches count], 1, @"Wrong amount of touches were found (touch ended)");
    XCTAssertEqual(_testUserInteractionObserver.currentEventType, CLUTestUserInteractionTouchEnded, @"Wrong touch type (touch ended)");
}

- (void)testTouchMoved {
    // Check if Gesture Recognizer enabled
    XCTAssertTrue(_gestureRecognizer.enabled, @"Gesture Recognizer is not enabled");
    
    // Test Touch Moved event
    // Every moved events are recording to buffer in order to relese this buffer user needs to perform Touch Ended event anfter Touch Moved
    // If this buffer isn't empty - gesture recognizer will call touchMoved: observer's method and after it - touchEnded:
    [_gestureRecognizer touchesMoved:[NSSet setWithObjects:_testTouch, _testNextTouch, nil] withEvent:_testEvent];
    [_gestureRecognizer touchesEnded:[NSSet setWithObject:_testTouch] withEvent:_testEvent];
    XCTAssertNotNil(_testUserInteractionObserver.currentMovedTouchesBuffer, @"Moved touches buffer is invalid (touch moved)");
    XCTAssertEqual([_testUserInteractionObserver.currentMovedTouchesBuffer count], 2, @"Wrong amount of touches were found (touch moved)");
    XCTAssertEqual(_testUserInteractionObserver.currentEventType, CLUTestUserInteractionTouchEnded, @"Wrong touch type (touch ended after moved)");
}

@end

@implementation CLUTestUserInteractionObserver

- (void)touchesBegan:(NSArray<CLUTouch *> *)touches {
    _currentTouches = touches;
    _currentEventType = CLUTestUserInteractionTouchBegan;
}

- (void)touchesMoved:(NSArray<CLUTouch *> *)touches {
    _currentMovedTouchesBuffer = touches;
    _currentEventType = CLUTestUserInteractionTouchMoved;
}

- (void)touchesEnded:(NSArray<CLUTouch *> *)touches {
    _currentTouches = touches;
    _currentEventType = CLUTestUserInteractionTouchEnded;
}

@end
