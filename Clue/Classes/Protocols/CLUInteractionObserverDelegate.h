//
//  CLUInteractionObserver.h
//  Clue
//
//  Created by Ahmed Sulaiman on 6/7/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLUTouch.h"

@protocol CLUInteractionObserverDelegate <NSObject>

@required
- (void)touchesBegan:(NSArray<CLUTouch *> *)touches;
- (void)touchesMoved:(NSArray<CLUTouch *> *)touches;
- (void)touchesEnded:(NSArray<CLUTouch *> *)touches;

@end
