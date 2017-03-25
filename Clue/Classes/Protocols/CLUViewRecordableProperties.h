//
//  CLUViewRecordableProperties.h
//  Clue
//
//  Created by Ahmed Sulaiman on 5/27/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 `CLUViewRecordableProperties` protocol describe common interface for  UIView's (and all subclasses) properties parsing into dictionary which will be used in JSON encoding to the specific file.
 
 @warning Needs to be implemented in all custom UIView related categories with properties parsing methods (see `UIView (CLUViewRecordableAdditions)`, `UILabel (CLUViewRecordableAdditions)`, `UIImageView (CLUViewRecordableAdditions)`, `UITextField (CLUViewRecordableAdditions)` for exmaples)
 */
@protocol CLUViewRecordableProperties <NSObject>

@required

/**
 Get `NSMutableDictionary` object with all properties and subviews of current UIView (or any subclass) object

 @return `NSMutableDictionary` object with all properties and subviews
 */
- (NSMutableDictionary *)clue_viewPropertiesDictionary;

@end
