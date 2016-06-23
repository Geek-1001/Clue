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
    [errorProperties setValue:[NSNumber numberWithInteger:self.code] forKey:@"code"];
    [errorProperties setValue:self.domain forKey:@"domain"];
    [errorProperties setValue:self.userInfo forKey:@"userInfo"];
    [errorProperties setValue:[self localizedDescription] forKey:@"localizedDescription"];
    [errorProperties setValue:[self localizedFailureReason] forKey:@"localizedFailureReason"];
    
    return errorProperties;
}

@end
