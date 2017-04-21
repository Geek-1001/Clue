//
//  NSException+CLUExceptionAdditions.m
//  Clue
//
//  Created by Ahmed Sulaiman on 6/30/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import "NSException+CLUExceptionAdditions.h"
#import "NSMutableDictionary+CLUUtilsAdditions.h"

@implementation NSException (CLUExceptionAdditions)

- (NSDictionary *)clue_exceptionProperties {
    if (!self) {
        return nil;
    }
    NSMutableDictionary *exceptionProperties = [[NSMutableDictionary alloc] init];
    [exceptionProperties clue_setValidObject:self.name forKey:@"name"];
    [exceptionProperties clue_setValidObject:self.reason forKey:@"reson"];
    [exceptionProperties clue_setValidObject:self.userInfo forKey:@"userInfo"];
    [exceptionProperties clue_setValidObject:[self callStackReturnAddresses]
                                      forKey:@"callStackReturnAddresses"];
    [exceptionProperties clue_setValidObject:[self callStackSymbols]
                                      forKey:@"callStackSymbols"];
    
    return exceptionProperties;
}

@end
