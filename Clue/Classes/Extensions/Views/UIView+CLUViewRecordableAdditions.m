//
//  UIView+CLUViewRecordableAdditions.m
//  Clue
//
//  Created by Ahmed Sulaiman on 5/27/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import "UIView+CLUViewRecordableAdditions.h"

@implementation UIView (CLUViewRecordableAdditions)

// It's root implementation, so it doesnt need to call super implementation
// This implementatio made basic structure of whole JSON document
- (NSMutableDictionary *)clue_viewPropertiesDictionary {
    if (!self) {
        return nil;
    }
    
    // TODO: set KEYs as a constants
    NSMutableDictionary *rootDictionary = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *propertiesDictionary = [[NSMutableDictionary alloc] init];
    NSMutableArray *subviewsArray = [[NSMutableArray alloc] init];
    
    [rootDictionary setValue:NSStringFromClass([self class]) forKey:@"class"];
    
    NSDictionary *framePropertyDictionary = [self clue_frameProprtyDictionary];
    [propertiesDictionary setValue:framePropertyDictionary forKey:@"frame"];
    NSDictionary *backgroundColorProperty = [self clue_backgroundColorPropertyDictionary];
    [propertiesDictionary setValue:backgroundColorProperty forKey:@"backgroundColor"];
    [propertiesDictionary setValue:[NSNumber numberWithBool:[self isHidden]] forKey:@"hidden"];
    // TODO: add Layer parsing
    [propertiesDictionary setValue:[NSNumber numberWithBool:[self isUserInteractionEnabled]] forKey:@"userInteractionEnabled"];
    NSDictionary *layoutMarginsProperty = [self clue_layoutMarginsPropertyDictionary];
    [propertiesDictionary setValue:layoutMarginsProperty forKey:@"layoutMargins"];
    [propertiesDictionary setValue:[NSNumber numberWithInteger:self.tag] forKey:@"tag"];
    [propertiesDictionary setValue:[NSNumber numberWithBool:[self isFocused]] forKey:@"focused"];
    
    [rootDictionary setValue:propertiesDictionary forKey:@"properties"];
    
    for (UIView *view in [self subviews]) {
        NSMutableDictionary *subviewPropertiesDictionary = [view clue_viewPropertiesDictionary];
        if (subviewPropertiesDictionary) {
            [subviewsArray addObject:subviewPropertiesDictionary];
        }
    }
    [rootDictionary setValue:subviewsArray forKey:@"subviews"];
                    
    return rootDictionary;
}

- (NSDictionary *)clue_frameProprtyDictionary {
    NSMutableDictionary *frameDictionary = [[NSMutableDictionary alloc] init];
    [frameDictionary setValue:[NSNumber numberWithFloat:self.frame.origin.x] forKey:@"x"];
    [frameDictionary setValue:[NSNumber numberWithFloat:self.frame.origin.y] forKey:@"y"];
    [frameDictionary setValue:[NSNumber numberWithFloat:self.frame.size.width] forKey:@"width"];
    [frameDictionary setValue:[NSNumber numberWithFloat:self.frame.size.height] forKey:@"height"];
    return frameDictionary;
}

- (NSDictionary *)clue_backgroundColorPropertyDictionary {
    NSMutableDictionary *backgroundDictionary = [[NSMutableDictionary alloc] init];
    CGFloat red, green, blue, alpha;
    [self.backgroundColor getRed:&red green:&green blue:&blue alpha:&alpha];
    [backgroundDictionary setValue:[NSNumber numberWithFloat:red] forKey:@"red"];
    [backgroundDictionary setValue:[NSNumber numberWithFloat:green] forKey:@"green"];
    [backgroundDictionary setValue:[NSNumber numberWithFloat:blue] forKey:@"blue"];
    [backgroundDictionary setValue:[NSNumber numberWithFloat:alpha] forKey:@"alpha"];
    return backgroundDictionary;
}

- (NSDictionary *)clue_layoutMarginsPropertyDictionary {
    NSMutableDictionary *marginsDictionary = [[NSMutableDictionary alloc] init];
    UIEdgeInsets margins = [self layoutMargins];
    [marginsDictionary setValue:[NSNumber numberWithFloat:margins.left] forKey:@"left"];
    [marginsDictionary setValue:[NSNumber numberWithFloat:margins.top] forKey:@"top"];
    [marginsDictionary setValue:[NSNumber numberWithFloat:margins.right] forKey:@"right"];
    [marginsDictionary setValue:[NSNumber numberWithFloat:margins.bottom] forKey:@"bottom"];
    return marginsDictionary;
}

@end
