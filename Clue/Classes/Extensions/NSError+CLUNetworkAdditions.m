//
//  NSError+CLUNetworkAdditions.m
//  Clue
//
//  Created by Ahmed Sulaiman on 6/23/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import "NSError+CLUNetworkAdditions.h"
#import "NSMutableDictionary+CLUUtilsAdditions.h"

@implementation NSError (CLUNetworkAdditions)

- (NSDictionary *)clue_errorProperties {
    if (!self) {
        return nil;
    }
    NSMutableDictionary *errorProperties = [[NSMutableDictionary alloc] init];
    [errorProperties setObject:NSStringFromClass([self class]) forKey:@"class"];
    [errorProperties setObject:@(self.code) forKey:@"code"];
    [errorProperties clue_setValidObject:self.domain forKey:@"domain"];
    [errorProperties clue_setValidObject:self.userInfo forKey:@"userInfo"];
    [errorProperties clue_setValidObject:self.localizedDescription forKey:@"localizedDescription"];
    [errorProperties clue_setValidObject:self.localizedFailureReason forKey:@"localizedFailureReason"];
    
    return errorProperties;
}

@end
