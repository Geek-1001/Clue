//
//  UILabel+CLUViewRecordableAdditions.m
//  Clue
//
//  Created by Ahmed Sulaiman on 5/27/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import "UILabel+CLUViewRecordableAdditions.h"
#import "UIView+CLUViewRecordableAdditions.h"
#import "NSMutableDictionary+CLUUtilsAdditions.h"

@implementation UILabel (CLUViewRecordableAdditions)

- (NSMutableDictionary *)clue_viewPropertiesDictionary {
    if (!self) {
        return nil;
    }
    NSMutableDictionary *rootDictionary = [super clue_viewPropertiesDictionary];
    NSMutableDictionary *propertiesDictionary = [rootDictionary objectForKey:@"properties"];
    
    [rootDictionary setObject:NSStringFromClass([self class]) forKey:@"class"];
    
    NSDictionary *attributedTextDictionary = [self clue_attributedTextPropertyDictionaryForAttributedString:self.attributedText];
    NSDictionary *fontDictionary = [self clue_fontPropertyDictionaryForFont:self.font];
    NSDictionary *textColorDictionary = [self clue_colorPropertyDictionaryForColor:self.textColor];
    NSDictionary *shadowColorDictionary = [self clue_colorPropertyDictionaryForColor:self.shadowColor];
    NSDictionary *shadowOffsetDictionary = [self clue_sizePropertyDictionaryForSize:self.shadowOffset];
    
    [propertiesDictionary clue_setValidAndNotEmptyString:self.text forKey:@"text"];
    [propertiesDictionary clue_setValidAndNotEmptyDictionary:attributedTextDictionary forKey:@"attributedText"];
    [propertiesDictionary clue_setValidAndNotEmptyDictionary:fontDictionary forKey:@"font"];
    [propertiesDictionary clue_setValidAndNotEmptyDictionary:textColorDictionary forKey:@"textColor"];
    [propertiesDictionary setObject:@(self.isEnabled) forKey:@"enabled"];
    [propertiesDictionary setObject:@(self.lineBreakMode) forKey:@"lineBreakMode"];
    [propertiesDictionary setObject:@(self.numberOfLines) forKey:@"numberOfLines"];
    [propertiesDictionary setObject:@(self.isHighlighted) forKey:@"highlighted"];
    [propertiesDictionary clue_setValidAndNotEmptyDictionary:shadowColorDictionary forKey:@"shadowColor"];
    [propertiesDictionary setObject:shadowOffsetDictionary forKey:@"shadowOffset"];
    
    [rootDictionary setObject:propertiesDictionary forKey:@"properties"];
    
    return rootDictionary;
}

@end
