//
//  UIView+CLUViewRecordableAdditions.h
//  Clue
//
//  Created by Ahmed Sulaiman on 5/27/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLUViewRecordableProperties.h"

/**
 `UIView (CLUViewRecordableAdditions)` category contains metho to parse `UIView` properties and encode them into json like dictionary
 To be able to include `UIView` properties into Clue report
*/
@interface UIView (CLUViewRecordableAdditions) <CLUViewRecordableProperties>

/**
 Generate color dictionary which includes red, green, blue and alpha value of specific color
 
 @param color Result color dictionary will be based on this `UIColor` object
 
 @return Color dictionary with data from selected `UIColor` object
 
 @code {
    "red" : <NSNumber>,
    "green" : <NSNumber>,
    "blue" : <NSNumber>,
    "alpha" : <NSNumber>
 }
*/
- (NSDictionary *)clue_colorPropertyDictionaryForColor:(UIColor *)color;

/**
 Generate size dictionary which includes width and height of specific size
 
 @param size Result size dictionary will be based on this `CGSize` value
 
 @return Size dictionary with data from selected `CGSize` value
 
 @code {
    "width" : <NSNumber>,
    "height" : <NSNumber>
 }
*/
- (NSDictionary *)clue_sizePropertyDictionaryForSize:(CGSize)size;

/**
 Generate font dictionary which includes familyName, fontName, pointSize and lineHeight of specific font
 
 @param font Result font dictionary will be based on this `UIFont` object
 
 @return Font dictionary with data from selected `UIFont` object
 
 @code {
    "familyName" : <NSString>,
    "fontName" : <NSString>,
    "pointSize" : <NSNumber>,
    "lineHeight" : <NSNumber>
 }
*/
- (NSDictionary *)clue_fontPropertyDictionaryForFont:(UIFont *)font;

/**
 Generate attributed string dictionary which includes string object of specific attributed string
 
 @param attributedText Result attributed string dictionary will be based on this `NSAttributedString` object
 
 @return Attributed String dictionary with data from selected `NSAttributedString` object
 
 @code {
    "string" : <NSString>
 }
*/
- (NSDictionary *)clue_attributedTextPropertyDictionaryForAttributedString:(NSAttributedString *)attributedText;

/**
 Generate layout margin dictionary which includes left, top, right and bottom margins for current `UIView` object
 
 @warning This method doesn't have any input, it generates dictionary based on current `UIView` object
 
 @return Layout Margin dictionary with data from current `UIView` object
 
 @code {
    "left" : <NSNumber>,
    "top" : <NSNumber>,
    "right" : <NSNumber>,
    "bottom" : <NSNumber>
 }
*/
- (NSDictionary *)clue_layoutMarginsPropertyDictionary;

/**
 Generate frame dictionary which includes x, y, width and height for current `UIView` object
 
 @warning This method doesn't have any input, it generates dictionary based on current `UIView` object
 
 @return Frame dictionary with data from current `UIView` object
 
 @code {
    "x" : <NSNumber>,
    "y" : <NSNumber>,
    "width" : <NSNumber>,
    "height" : <NSNumber>
 }
 */
- (NSDictionary *)clue_frameProprtyDictionary;

@end
