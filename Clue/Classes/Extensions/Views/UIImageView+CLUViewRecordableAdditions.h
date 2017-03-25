//
//  UIImageView+CLUViewRecordableAdditions.h
//  Clue
//
//  Created by Ahmed Sulaiman on 5/30/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLUViewRecordableProperties.h"

/**
 `UIImageView (CLUViewRecordableAdditions)` category contains methods to parse `UIImageView` properties and encode them into json like dictionary
 To be able to include `UIImageView` properties into Clue report.

 Specifically method `[UIImageView  clue_viewPropertiesDictionary]` from `CLUViewRecordableProperties` protocol.
 It use root method of `UIView` and add some `UIImageView` specific properties and return full dictionary
 */
@interface UIImageView (CLUViewRecordableAdditions) <CLUViewRecordableProperties>

@end
