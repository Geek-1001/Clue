//
//  UIView+CLUViewRecordableAdditions.m
//  Clue
//
//  Created by Ahmed Sulaiman on 5/27/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import "UIView+CLUViewRecordableAdditions.h"
#import "NSMutableDictionary+CLUUtilsAdditions.h"

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
    NSMutableArray<NSDictionary *> *subviewsArray = [[NSMutableArray alloc] init];
    
    [rootDictionary setObject:NSStringFromClass([self class]) forKey:@"class"];
    
    NSDictionary *framePropertyDictionary = [self clue_frameProprtyDictionary];
    NSDictionary *backgroundColorProperty = [self clue_colorPropertyDictionaryForColor:self.backgroundColor];
    NSDictionary *layoutMarginsProperty = [self clue_layoutMarginsPropertyDictionary];
    
    [propertiesDictionary setObject:framePropertyDictionary forKey:@"frame"];
    [propertiesDictionary clue_setValidObject:backgroundColorProperty forKey:@"backgroundColor"];
    [propertiesDictionary setObject:@(self.isHidden) forKey:@"hidden"];
    // TODO: add Layer parsing
    [propertiesDictionary setObject:@(self.isUserInteractionEnabled) forKey:@"userInteractionEnabled"];
    [propertiesDictionary setObject:layoutMarginsProperty forKey:@"layoutMargins"];
    [propertiesDictionary setObject:@(self.tag) forKey:@"tag"];
    [propertiesDictionary setObject:@(self.isFocused) forKey:@"focused"];
    
    [rootDictionary setObject:propertiesDictionary forKey:@"properties"];
    
    for (UIView *view in [self subviews]) {
        NSMutableDictionary *subviewPropertiesDictionary = [view clue_viewPropertiesDictionary];
        if (subviewPropertiesDictionary) {
            [subviewsArray addObject:subviewPropertiesDictionary];
        }
    }
    [rootDictionary setObject:subviewsArray forKey:@"subviews"];
                    
    return rootDictionary;
}

// TODO: if color is nil – return nil
- (NSDictionary *)clue_colorPropertyDictionaryForColor:(UIColor *)color {
    NSMutableDictionary *colorDictionary = [[NSMutableDictionary alloc] init];
    if (color) {
        CGFloat red, green, blue, alpha;
        [color getRed:&red green:&green blue:&blue alpha:&alpha];
        [colorDictionary setObject:@(red) forKey:@"red"];
        [colorDictionary setObject:@(green) forKey:@"green"];
        [colorDictionary setObject:@(blue) forKey:@"blue"];
        [colorDictionary setObject:@(alpha) forKey:@"alpha"];
    }
    return colorDictionary;
}

- (NSDictionary *)clue_sizePropertyDictionaryForSize:(CGSize)size {
    NSMutableDictionary *sizeDictionary = [[NSMutableDictionary alloc] init];
    [sizeDictionary setObject:@(size.width) forKey:@"width"];
    [sizeDictionary setObject:@(size.height) forKey:@"height"];
    return sizeDictionary;
}

- (NSDictionary *)clue_frameProprtyDictionary {
    NSMutableDictionary *frameDictionary = [[NSMutableDictionary alloc] init];
    [frameDictionary setObject:@(self.frame.origin.x) forKey:@"x"];
    [frameDictionary setObject:@(self.frame.origin.y) forKey:@"y"];
    [frameDictionary setObject:@(self.frame.size.width) forKey:@"width"];
    [frameDictionary setObject:@(self.frame.size.height) forKey:@"height"];
    return frameDictionary;
}

- (NSDictionary *)clue_layoutMarginsPropertyDictionary {
    NSMutableDictionary *marginsDictionary = [[NSMutableDictionary alloc] init];
    UIEdgeInsets margins = [self layoutMargins];
    [marginsDictionary setObject:@(margins.left) forKey:@"left"];
    [marginsDictionary setObject:@(margins.top) forKey:@"top"];
    [marginsDictionary setObject:@(margins.right) forKey:@"right"];
    [marginsDictionary setObject:@(margins.bottom) forKey:@"bottom"];
    return marginsDictionary;
}

// TODO: if font is nil – return nil
- (NSDictionary *)clue_fontPropertyDictionaryForFont:(UIFont *)font {
    NSMutableDictionary *fontDictionary = [[NSMutableDictionary alloc] init];
    if (font) {
        [fontDictionary clue_setValidObject:font.familyName forKey:@"familyName"];
        [fontDictionary clue_setValidObject:font.fontName forKey:@"fontName"];
        [fontDictionary setObject:@(font.pointSize) forKey:@"pointSize"];
        [fontDictionary setObject:@(font.lineHeight) forKey:@"lineHeight"];
    }
    return fontDictionary;
}

// TODO: if attributedText is nil – return nil
- (NSDictionary *)clue_attributedTextPropertyDictionaryForAttributedString:(NSAttributedString *)attributedText {
    NSMutableDictionary *attributedTextDictionary = [[NSMutableDictionary alloc] init];
    if (attributedText) {
        [attributedTextDictionary clue_setValidObject:[attributedText string] forKey:@"string"];
    }
    // TODO: add Retrieving Attribute Information
    return attributedTextDictionary;
}

@end
