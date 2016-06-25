//
//  NSError+CLUNetworkAdditions.m
//  Clue
//
//  Created by Ahmed Sulaiman on 6/23/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import "NSError+CLUNetworkAdditions.h"

@implementation NSError (CLUNetworkAdditions)

- (NSDictionary *)clue_errorProperties {
    if (!self) {
        return nil;
    }
    NSMutableDictionary *errorProperties = [[NSMutableDictionary alloc] init];
    [errorProperties setObject:NSStringFromClass([self class]) forKey:@"class"];
    [errorProperties setObject:@(self.code) forKey:@"code"];
    [errorProperties setObject:self.domain ? self.domain : @"" forKey:@"domain"];
    [errorProperties setObject:self.userInfo ? self.userInfo : @"" forKey:@"userInfo"];
    [errorProperties setObject:self.localizedDescription ? self.localizedDescription : @"" forKey:@"localizedDescription"];
    [errorProperties setObject:self.localizedFailureReason ? self.localizedFailureReason : @"" forKey:@"localizedFailureReason"];
    
    return errorProperties;
}

@end
