//
//  UITextField+CLUViewRecordableAdditions.h
//  Clue
//
//  Created by Ahmed Sulaiman on 5/30/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLUViewRecordableProperties.h"

/**
 `UITextField (CLUViewRecordableAdditions)` category contains methods to parse `UITextField` properties and encode them into json like dictionary
 To be able to include `UITextField` properties into Clue report.
 
 Specifically method `[UITextField  clue_viewPropertiesDictionary]` from `CLUViewRecordableProperties` protocol.
 It use root method of `UIView` and add some `UITextField` specific properties and return full dictionary
 */
@interface UITextField (CLUViewRecordableAdditions) <CLUViewRecordableProperties>

@end
