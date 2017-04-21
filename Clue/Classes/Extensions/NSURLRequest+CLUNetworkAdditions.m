//
//  NSURLRequest+CLUNetworkAdditions.m
//  Clue
//
//  Created by Ahmed Sulaiman on 6/23/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import "NSURLRequest+CLUNetworkAdditions.h"
#import "NSMutableDictionary+CLUUtilsAdditions.h"

@implementation NSURLRequest (CLUNetworkAdditions)

- (NSDictionary *)clue_requestProperties {
    if (!self) {
        return nil;
    }
    NSMutableDictionary *requestProperties = [[NSMutableDictionary alloc] init];
    [requestProperties setObject:NSStringFromClass([self class]) forKey:@"class"];
    [requestProperties clue_setValidObject:self.URL.absoluteString forKey:@"URL"];
    [requestProperties clue_setValidObject:self.allHTTPHeaderFields forKey:@"allHTTPHeaderFields"];
    [requestProperties clue_setValidObject:self.HTTPMethod forKey:@"HTTPMethod"];
    [requestProperties setObject:@(self.HTTPShouldHandleCookies) forKey:@"HTTPShouldHandleCookies"];
    if (self.HTTPBody) {
        NSString *bodyString = [[NSString alloc] initWithData:self.HTTPBody encoding:NSUTF8StringEncoding];
        [requestProperties setObject:bodyString forKey:@"HTTPBody"];
    }
    
    return requestProperties;
}

@end
