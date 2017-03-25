//
//  CLUExceptionInfoModule.h
//  Clue
//
//  Created by Ahmed Sulaiman on 7/12/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLUInfoModule.h"

/**
 `CLUExceptionInfoModule` is a info module (with static, one-time informations) for unexpected exception recording if occurred.
 */
@interface CLUExceptionInfoModule : NSObject <CLUInfoModule>

/**
 This `NSException` exception object will be be recorded
 */
@property (nonatomic) NSException *exception;

@end
