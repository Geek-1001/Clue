//
//  CLUGeneralGestureRecognizerTests.m
//  Clue
//
//  Created by Ahmed Sulaiman on 3/11/17.
//  Copyright © 2017 Ahmed Sulaiman. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CLUGeneralGestureRecognizer.h"

@interface CLUGeneralGestureRecognizerTests : XCTestCase
@end

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

@implementation CLUGeneralGestureRecognizerTests

- (void)testTouches {
    // Initialize test variables
    UIView *testView = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    CLUTestUserInteractionObserver *testUserInteractionObserver = [[CLUTestUserInteractionObserver alloc] init];
    UITouch *testTouch = [[UITouch alloc] init];
    UITouch *testNextTouch = [[UITouch alloc] init];
    UIEvent *testEvent = [[UIEvent alloc] init];

    // Initialize Gesture Recognizer
    CLUGeneralGestureRecognizer *gestureRecognizer = [[CLUGeneralGestureRecognizer alloc] init];
    XCTAssertNotNil(gestureRecognizer, @"Gesture Recognizer failed to initialize");
    [gestureRecognizer setObserverDelegate:testUserInteractionObserver];
    
    // Attach Gesture Recognizer to Test View
    [testView addGestureRecognizer:gestureRecognizer];
    XCTAssertEqual([testView.gestureRecognizers count], 1, @"Undefined gesture recognizer attached to Test View");
    XCTAssertEqual(gestureRecognizer.view, testView, @"Gesture recognizer attached to wrong view");
    
    // Check if Gesture Recognizer enabled
    XCTAssertTrue(gestureRecognizer.enabled, @"Gesture Recognizer is not enabled");
    
    // Test Touch Began event
    [gestureRecognizer touchesBegan:[NSSet setWithObject:testTouch] withEvent:testEvent];
    XCTAssertNotNil(testUserInteractionObserver.currentTouches, @"Current touches are invalid (touch began)");
    XCTAssertEqual([testUserInteractionObserver.currentTouches count], 1, @"Wrong amount of touches were found (touch began)");
    XCTAssertEqual(testUserInteractionObserver.currentEventType, CLUTestUserInteractionTouchBegan, @"Wrong touch type (touch began)");
    
    // Test Touch Ended event
    [gestureRecognizer touchesEnded:[NSSet setWithObject:testTouch] withEvent:testEvent];
    XCTAssertEqual([testUserInteractionObserver.currentTouches count], 1, @"Wrong amount of touches were found (touch ended)");
    XCTAssertEqual(testUserInteractionObserver.currentEventType, CLUTestUserInteractionTouchEnded, @"Wrong touch type (touch ended)");
    
    // Test Touch Moved event
    // Every moved events are recording to buffer in order to relese this buffer user needs to perform Touch Ended event anfter Touch Moved
    // If this buffer isn't empty - gesture recognizer will call touchMoved: observer's method and after it - touchEnded:
    [gestureRecognizer touchesMoved:[NSSet setWithObjects:testTouch, testNextTouch, nil] withEvent:testEvent];
    [gestureRecognizer touchesEnded:[NSSet setWithObject:testTouch] withEvent:testEvent];
    XCTAssertNotNil(testUserInteractionObserver.currentMovedTouchesBuffer, @"Moved touches buffer is invalid (touch moved)");
    XCTAssertEqual([testUserInteractionObserver.currentMovedTouchesBuffer count], 2, @"Wrong amount of touches were found (touch moved)");
    XCTAssertEqual(testUserInteractionObserver.currentEventType, CLUTestUserInteractionTouchEnded, @"Wrong touch type (touch ended after moved)");
    
    // Remove gesture recognizer from test view and remove observer
    [testView removeGestureRecognizer:gestureRecognizer];
    [gestureRecognizer removeObserverDelegate];
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
