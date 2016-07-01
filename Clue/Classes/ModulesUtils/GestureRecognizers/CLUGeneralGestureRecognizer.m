//
//  CLUGeneralGestureRecognizer.m
//  Clue
//
//  Created by Ahmed Sulaiman on 6/7/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import "CLUGeneralGestureRecognizer.h"

@interface CLUGeneralGestureRecognizer()

@property (nonatomic) NSMutableArray<CLUTouch *> *movedTouchesBuffer;
@property (nonatomic) id <CLUInteractionObserverDelegate> observerDelegate;

@end

@implementation CLUGeneralGestureRecognizer

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    self.cancelsTouchesInView = NO;
    _movedTouchesBuffer = [[NSMutableArray alloc] init];
    return self;
}

- (void)reset {
    [super reset];
    [_movedTouchesBuffer removeAllObjects];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self setState:UIGestureRecognizerStatePossible];
    if (_observerDelegate) {
        NSArray<CLUTouch *> *receivedTouches = [self copyTouches:touches];
        [_observerDelegate touchesBegan:receivedTouches];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    NSArray<CLUTouch *> *receivedTouches = [self copyTouches:touches];
    [_movedTouchesBuffer addObjectsFromArray:receivedTouches];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    [self setState:UIGestureRecognizerStateEnded];
    if (_observerDelegate) {
        if ([_movedTouchesBuffer count] > 0) {
            [_observerDelegate touchesMoved:_movedTouchesBuffer];
        }
        NSArray<CLUTouch *> *receivedTouches = [self copyTouches:touches];
        [_observerDelegate touchesEnded:receivedTouches];
    }
}

- (NSArray<CLUTouch *> *)copyTouches:(NSSet<UITouch *> *)touches {
    NSMutableArray<CLUTouch *> *receivedTouches = [[NSMutableArray alloc] init];
    for (UITouch *touch in touches) {
        CLUTouch *receivedTouch = [[CLUTouch alloc] initWithTouch:touch];
        [receivedTouches addObject:receivedTouch];
    }
    
    return receivedTouches;
}

- (void)setObserverDelegate:(id <CLUInteractionObserverDelegate>)delegate {
    _observerDelegate = delegate;
}

- (void)removeObserverDelegate {
    _observerDelegate = nil;
}

@end
