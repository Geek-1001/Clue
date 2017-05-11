//
//  CLUInteractionObserver.h
//  Clue
//
//  Created by Ahmed Sulaiman on 6/7/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLUTouch.h"

/**
 `CLUInteractionObserverDelegate` protocol describe delegate methods which will handle all touches events sent by custom gesture recognizer (see `CLUGeneralGestureRecognizer`)
 */
@protocol CLUInteractionObserverDelegate <NSObject>

@required

/**
 Tells current delegate object that one or more new touches occurred

 @param touches Array of `CLUTouch` touches object (which is just a proxy for `UITouch`)
 */
- (void)touchesBegan:(nonnull NSArray<CLUTouch *> *)touches;

/**
 Tells current delegate object that moved gesture occured. Called only once at the end of moved event.

 @param touches Array of `CLUTouch` touches object (which is just a proxy for `UITouch`)
 */
- (void)touchesMoved:(nonnull NSArray<CLUTouch *> *)touches;

/**
 Tells current delegate object that one or more fingers are raised

 @param touches Array of `CLUTouch` touches object (which is just a proxy for `UITouch`)
 */
- (void)touchesEnded:(nonnull NSArray<CLUTouch *> *)touches;

@end
