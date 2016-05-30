//
//  UIImageView+CLUViewRecordableAdditions.m
//  Clue
//
//  Created by Ahmed Sulaiman on 5/30/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import "UIImageView+CLUViewRecordableAdditions.h"
#import "UIView+CLUViewRecordableAdditions.h"

@implementation UIImageView (CLUViewRecordableAdditions)

- (NSMutableDictionary *)clue_viewPropertiesDictionary {
    if (!self) {
        return nil;
    }
    NSMutableDictionary *rootDictionary = [super clue_viewPropertiesDictionary];
    NSDictionary *propertiesDictionary = [rootDictionary valueForKey:@"properties"];
    
    [rootDictionary setValue:NSStringFromClass([self class]) forKey:@"class"];
    
    [propertiesDictionary setValue:[self image] forKey:@"image"];
    [propertiesDictionary setValue:[self highlightedImage] forKey:@"highlightedImage"];
    [propertiesDictionary setValue:[NSNumber numberWithBool:[self isAnimating]] forKey:@"isAnimating"];
    [propertiesDictionary setValue:[self animationImages] forKey:@"animationImages"];
    [propertiesDictionary setValue:[self highlightedAnimationImages] forKey:@"highlightedAnimationImages"];
    [propertiesDictionary setValue:[NSNumber numberWithDouble:[self animationDuration]] forKey:@"animationDuration"];
    [propertiesDictionary setValue:[NSNumber numberWithInteger:[self animationRepeatCount]] forKey:@"animationRepeatCount"];
    [propertiesDictionary setValue:[NSNumber numberWithBool:[self isHighlighted]] forKey:@"highlighted"];
    
    [rootDictionary setValue:propertiesDictionary forKey:@"properties"];
    
    return rootDictionary;
}

@end
