//
//  CLUInfoModule.h
//  Clue
//
//  Created by Ahmed Sulaiman on 7/9/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLUWritable.h"

/**
 `CLUInfoModule` protocol describe info modules (like Device Info module or Exception module), static one-time modules which needs to write their data only once during recording.
 
 @warning Every info modules have to implement this protocol to be able to work normally inside the system
 */
@protocol CLUInfoModule <NSObject>

@required

/**
 Initialize info module with specific writer which implements `CLUWritable` protocol. So module will be able to record/write required information.
 
 @param writer Writer object which implements `CLUWritable` protocol. Responsible for actual writing information to some specific file
 @return New instance of info module
 */
- (instancetype)initWithWriter:(id <CLUWritable>)writer;

/**
 Record actual information once and cleanup everything
 */
- (void)recordInfoData;

@end
