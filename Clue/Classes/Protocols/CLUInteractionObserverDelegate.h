//
//  CLUInteractionObserver.h
//  Clue
//
//  Created by Ahmed Sulaiman on 6/7/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol CLUInteractionObserverDelegate <NSObject>

@required
- (void)touchesBegan:(NSSet<UITouch *> *)touches;
- (void)touchesMoved:(NSArray<UITouch *> *)touches;
- (void)touchesEnded:(NSSet<UITouch *> *)touches;

@end
