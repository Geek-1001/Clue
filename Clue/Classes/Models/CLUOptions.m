//
//  CLUOptions.m
//  Clue
//
//  Created by Ahmed Sulaiman on 5/11/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import "CLUOptions.h"

@implementation CLUOptions

+ (instancetype)optionsWithEmail:(NSString *)email {
    CLUOptions *instance = [[self alloc] init];
    [instance setEmail:email];
    return instance;
}

@end
