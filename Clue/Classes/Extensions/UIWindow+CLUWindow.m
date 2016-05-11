//
//  UIWindow+CLUWindow.m
//  Clue
//
//  Created by Ahmed Sulaiman on 5/11/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import "UIWindow+CLUWindow.h"
#import <objc/runtime.h>

@implementation UIWindow (CLUWindow)

- (Clue *)clue {
    Clue *clue = objc_getAssociatedObject(self, ClueAssociationKey);
    if (!clue) {
        clue = [[Clue alloc] initWithWindow:self];
        objc_setAssociatedObject(self, ClueAssociationKey, clue, OBJC_ASSOCIATION_RETAIN);
    }
    return clue;
}

@end
