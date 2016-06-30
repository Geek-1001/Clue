//
//  NSException+CLUExceptionAdditions.m
//  Clue
//
//  Created by Ahmed Sulaiman on 6/30/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import "NSException+CLUExceptionAdditions.h"

@implementation NSException (CLUExceptionAdditions)

- (NSDictionary *)clue_exceptionProperties {
    if (!self) {
        return nil;
    }
    NSMutableDictionary *exceptionProperties = [[NSMutableDictionary alloc] init];
    [exceptionProperties setObject:self.name ? self.name : @""
                            forKey:@"name"];
    [exceptionProperties setObject:self.reason ? self.reason : @""
                            forKey:@"reson"];
    [exceptionProperties setObject:self.userInfo ? self.userInfo : @""
                            forKey:@"userInfo"];
    [exceptionProperties setObject:[self callStackReturnAddresses] ? [self callStackReturnAddresses] : @""
                            forKey:@"callStackReturnAddresses"];
    [exceptionProperties setObject:[self callStackSymbols] ? [self callStackSymbols] : @""
                            forKey:@"callStackSymbols"];
    
    return exceptionProperties;
}

@end
