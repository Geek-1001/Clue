//
//  NSURLRequest+CLUNetworkAdditions.m
//  Clue
//
//  Created by Ahmed Sulaiman on 6/23/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import "NSURLRequest+CLUNetworkAdditions.h"

@implementation NSURLRequest (CLUNetworkAdditions)

- (NSDictionary *)clue_requestProperties {
    if (!self) {
        return nil;
    }
    NSMutableDictionary *requestProperties = [[NSMutableDictionary alloc] init];
    [requestProperties setValue:self.URL forKey:@"URL"];
    [requestProperties setValue:self.allHTTPHeaderFields forKey:@"allHTTPHeaderFields"];
    [requestProperties setValue:self.HTTPMethod forKey:@"HTTPMethod"];
    [requestProperties setValue:@(self.HTTPShouldHandleCookies) forKey:@"HTTPShouldHandleCookies"];
    if (self.HTTPBody) {
        NSString *bodyString = [[NSString alloc] initWithData:self.HTTPBody encoding:NSUTF8StringEncoding];
        [requestProperties setValue:bodyString forKey:@"HTTPBody"];
    }
    
    return requestProperties;
}

@end
