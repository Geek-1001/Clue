//
//  CLUGeneralGestureRecognizer.h
//  Clue
//
//  Created by Ahmed Sulaiman on 6/7/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UIKit/UIGestureRecognizerSubclass.h>
#import "CLUInteractionObserverDelegate.h"

@interface CLUGeneralGestureRecognizer : UIGestureRecognizer

- (void)setObserverDelegate:(id <CLUInteractionObserverDelegate>)delegate;
- (void)removeObserverDelegate;

@end
