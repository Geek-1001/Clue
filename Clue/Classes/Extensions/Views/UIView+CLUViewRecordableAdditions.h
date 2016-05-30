//
//  UIView+CLUViewRecordableAdditions.h
//  Clue
//
//  Created by Ahmed Sulaiman on 5/27/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLUViewRecordableProperties.h"

@interface UIView (CLUViewRecordableAdditions) <CLUViewRecordableProperties>

- (NSDictionary *)clue_colorPropertyDictionaryForColor:(UIColor *)color;
- (NSDictionary *)clue_sizePropertyDictionaryForSize:(CGSize)size;
- (NSDictionary *)clue_fontPropertyDictionaryForFont:(UIFont *)font;
- (NSDictionary *)clue_attributedTextPropertyDictionaryForAttributedString:(NSAttributedString *)attributedText;

@end
