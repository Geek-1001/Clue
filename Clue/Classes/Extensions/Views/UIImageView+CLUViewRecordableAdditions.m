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
    NSMutableDictionary *propertiesDictionary = [rootDictionary objectForKey:@"properties"];
    
    [rootDictionary setObject:NSStringFromClass([self class]) forKey:@"class"];

    // TODO: Save image in a different way
//    [propertiesDictionary setObject:[self image] forKey:@"image"];
//    [propertiesDictionary setObject:[self highlightedImage] forKey:@"highlightedImage"];
//    [propertiesDictionary setObject:[self animationImages] forKey:@"animationImages"];
//    [propertiesDictionary setObject:[self highlightedAnimationImages] forKey:@"highlightedAnimationImages"];
    [propertiesDictionary setObject:@(self.isAnimating) forKey:@"isAnimating"];
    [propertiesDictionary setObject:@(self.animationDuration) forKey:@"animationDuration"];
    [propertiesDictionary setObject:@(self.animationRepeatCount) forKey:@"animationRepeatCount"];
    [propertiesDictionary setObject:@(self.isHighlighted) forKey:@"highlighted"];
    
    [rootDictionary setObject:propertiesDictionary forKey:@"properties"];
    
    return rootDictionary;
}

@end
