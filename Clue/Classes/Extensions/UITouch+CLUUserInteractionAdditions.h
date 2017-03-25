//
//  UITouch+CLUUserInteractionAdditions.h
//  Clue
//
//  Created by Ahmed Sulaiman on 6/7/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 `UITouch (CLUUserInteractionAdditions)` category contains method to parse `UITouch` properties and encode them into json like dictionary
 To be able to include `UITouch` properties into Clue report (User Interaction module)
 
 @warning This `UITouch (CLUUserInteractionAdditions)` category is not used for now. Properties parsing method is located in `CLUTouch` proxy class
*/
@interface UITouch (CLUUserInteractionAdditions)

/**
 Generate touch dictionary which includes tapCount and locationInWindow for current `UITouch` object
 
 @warning This method doesn't have any input, it generates dictionary based on current `UITouch` object
 
 @return Touch dictionary with data from current `UITouch` object
 
 @code {
    "tapCount" : <NSNumber>,
    "locationInWindow" : {
        "x" : <NSNumber>,
        "y" : <NSNumber>,
    }
 }
*/
- (NSDictionary *)clue_touchProperties;

@end
