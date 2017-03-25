//
//  CLUTouch.h
//  Clue
//
//  Created by Ahmed Sulaiman on 7/1/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 @brief `CLUTouch` is a proxy for UITouch data and properties dictionary generator for this data.
 
 @discussion `CLUTouch` is a data model to store UITouch's data in appropriate way. Since the system reuse UITouch object with each user interaction we can't just store in in out collection in order to generate their properties data dictionary (via UITouch category) and add this data to final report file. Instead we have to transfer UITouch values to our custom class `CLUTouch` and interaction with it.
 
 Used in `CLUGeneralGestureRecognizer` in order to transfer UITouch to CLUTouch.  Also `CLUInteractionObserverDelegate` protocol requires CLUTouch instead of UITouch
 */
@interface CLUTouch : NSObject

@property (nonatomic, readonly) CGPoint locationInWindow;
@property (nonatomic, readonly) NSInteger tapCount;

/**
 Create new instance of CLUTouch object with data from UITouch object
 
 @param touch system generated UITouch object (usually from touchBegan: touchMoved: or touchEnded: methods)
 
 @return CLUTouch instance with data from UITouch object
 */
- (instancetype)initWithTouch:(UITouch *)touch;

/**
 Generate serialized properties dictionary with all required values there `locationInWindow` and `tapCount`
 To use this dictionary in final report writing process
 
 @return dictionary with properties of `CLUTouch`
 */
- (NSDictionary *)properties;

@end
