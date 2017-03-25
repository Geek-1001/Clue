//
//  UILabel+CLUViewRecordableAdditions.h
//  Clue
//
//  Created by Ahmed Sulaiman on 5/27/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLUViewRecordableProperties.h"

/**
 `UILabel (CLUViewRecordableAdditions)` category contains methods to parse `UILabel` properties and encode them into json like dictionary
 To be able to include `UILabel` properties into Clue report. 

 Specifically method `[UILabel  clue_viewPropertiesDictionary]` from `CLUViewRecordableProperties` protocol. 
 It use root method of `UIView` and add some `UILabel` specific properties and return full dictionary
 */
@interface UILabel (CLUViewRecordableAdditions) <CLUViewRecordableProperties>

@end
