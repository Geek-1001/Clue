//
//  UILabel+CLUViewRecordableAdditions.m
//  Clue
//
//  Created by Ahmed Sulaiman on 5/27/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import "UILabel+CLUViewRecordableAdditions.h"
#import "UIView+CLUViewRecordableAdditions.h"

@implementation UILabel (CLUViewRecordableAdditions)

- (NSMutableDictionary *)clue_viewPropertiesDictionary {
    if (!self) {
        return nil;
    }
    NSMutableDictionary *rootDictionary = [super clue_viewPropertiesDictionary];
    NSDictionary *propertiesDictionary = [rootDictionary valueForKey:@"properties"];
    
    [rootDictionary setValue:NSStringFromClass([self class]) forKey:@"class"];
    
    NSDictionary *attributedTextDictionary = [self clue_attributedTextPropertyDictionary];
    NSDictionary *fontDictionary = [self clue_fontPropertyDictionary];
    NSDictionary *textColorDictionary = [self clue_colorPropertyDictionaryForColor:self.textColor];
    NSDictionary *highlightedTextColorDictionary = [self clue_colorPropertyDictionaryForColor:self.highlightedTextColor];
    NSDictionary *shadowColorDictionary = [self clue_colorPropertyDictionaryForColor:self.shadowColor];
    NSDictionary *shadowOffsetDictionary = [self clue_sizePropertyDictionaryForSize:self.shadowOffset];
    
    [propertiesDictionary setValue:self.text forKey:@"text"];
    [propertiesDictionary setValue:attributedTextDictionary forKey:@"attributedText"];
    [propertiesDictionary setValue:fontDictionary forKey:@"font"];
    [propertiesDictionary setValue:textColorDictionary forKey:@"textColor"];
    [propertiesDictionary setValue:[NSNumber numberWithBool:[self isEnabled]] forKey:@"enabled"];
    [propertiesDictionary setValue:[NSNumber numberWithInteger:[self lineBreakMode]] forKey:@"lineBreakMode"];
    [propertiesDictionary setValue:[NSNumber numberWithInteger:[self numberOfLines]] forKey:@"numberOfLines"];
    [propertiesDictionary setValue:[NSNumber numberWithBool:[self isHighlighted]] forKey:@"highlighted"];
    [propertiesDictionary setValue:highlightedTextColorDictionary forKey:@"highlightedTextColor"];
    [propertiesDictionary setValue:shadowColorDictionary forKey:@"shadowColor"];
    [propertiesDictionary setValue:shadowOffsetDictionary forKey:@"shadowOffset"];
    
    [rootDictionary setValue:propertiesDictionary forKey:@"properties"];
    
    return rootDictionary;
}

- (NSMutableDictionary *)clue_attributedTextPropertyDictionary {
    NSMutableDictionary *attributedTextDictionary = [[NSMutableDictionary alloc] init];
    NSAttributedString *atrubutedText = self.attributedText;
    [attributedTextDictionary setValue:[atrubutedText string] forKey:@"string"];
    // TODO: add Retrieving Attribute Information
    return attributedTextDictionary;
}

- (NSMutableDictionary *)clue_fontPropertyDictionary {
    NSMutableDictionary *fontDictionary = [[NSMutableDictionary alloc] init];
    UIFont *font = self.font;
    [fontDictionary setValue:font.familyName forKey:@"familyName"];
    [fontDictionary setValue:font.fontName forKey:@"fontName"];
    [fontDictionary setValue:[NSNumber numberWithFloat:font.pointSize] forKey:@"pointSize"];
    [fontDictionary setValue:[NSNumber numberWithFloat:font.lineHeight] forKey:@"lineHeight"];
    return fontDictionary;
}

@end
