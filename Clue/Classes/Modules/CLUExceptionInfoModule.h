//
//  CLUExceptionInfoModule.h
//  Clue
//
//  Created by Ahmed Sulaiman on 7/12/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLUInfoModule.h"

@interface CLUExceptionInfoModule : NSObject <CLUInfoModule>

@property (nonatomic) NSException *exception;

@end
