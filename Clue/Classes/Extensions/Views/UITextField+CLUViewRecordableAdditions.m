//
//  UITextField+CLUViewRecordableAdditions.m
//  Clue
//
//  Created by Ahmed Sulaiman on 5/30/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import "UITextField+CLUViewRecordableAdditions.h"
#import "UIView+CLUViewRecordableAdditions.h"
#import "NSMutableDictionary+CLUUtilsAdditions.h"

@implementation UITextField (CLUViewRecordableAdditions)

- (NSMutableDictionary *)clue_viewPropertiesDictionary {
    if (!self) {
        return nil;
    }
    NSMutableDictionary *rootDictionary = [super clue_viewPropertiesDictionary];
    NSMutableDictionary *propertiesDictionary = [rootDictionary objectForKey:@"properties"];
    
    [rootDictionary setObject:NSStringFromClass([self class]) forKey:@"class"];
    
    NSDictionary *attributedTextDictionary = [self clue_attributedTextPropertyDictionaryForAttributedString:[self attributedText]];
    NSDictionary *attributedPlaceholderDictionary = [self clue_attributedTextPropertyDictionaryForAttributedString:[self attributedPlaceholder]];
    NSDictionary *fontDictionary = [self clue_fontPropertyDictionaryForFont:self.font];
    NSDictionary *textColorDicitonary = [self clue_colorPropertyDictionaryForColor:[self textColor]];

    [propertiesDictionary clue_setValidObject:self.text forKey:@"text"];
    [propertiesDictionary clue_setValidObject:attributedTextDictionary forKey:@"attributedText"];
    [propertiesDictionary clue_setValidObject:self.placeholder forKey:@"placeholder"];
    [propertiesDictionary clue_setValidObject:attributedPlaceholderDictionary forKey:@"attributedPlaceholder"];
    [propertiesDictionary clue_setValidObject:fontDictionary forKey:@"font"];
    [propertiesDictionary clue_setValidObject:textColorDicitonary forKey:@"textColor"];
    [propertiesDictionary setObject:@(self.minimumFontSize) forKey:@"minimumFontSize"];
    [propertiesDictionary setObject:@(self.isEditing) forKey:@"editing"];
    [propertiesDictionary setObject:@(self.borderStyle) forKey:@"borderStyle"];
    // TODO: Save image in a different way
//    [propertiesDictionary setObject:[self background] forKey:@"background"];
//    [propertiesDictionary setObject:[self disabledBackground] forKey:@"disabledBackground"];
    
    [rootDictionary setObject:propertiesDictionary forKey:@"properties"];
    
    return rootDictionary;
}

@end
