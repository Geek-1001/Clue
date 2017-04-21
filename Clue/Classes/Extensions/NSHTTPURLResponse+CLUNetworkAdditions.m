//
//  NSHTTPURLResponse+CLUNetworkAdditions.m
//  Clue
//
//  Created by Ahmed Sulaiman on 6/23/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import "NSHTTPURLResponse+CLUNetworkAdditions.h"
#import "NSURLResponse+CLUNetworkAdditions.h"
#import "NSMutableDictionary+CLUUtilsAdditions.h"

@implementation NSHTTPURLResponse (CLUNetworkAdditions)

- (NSDictionary *)clue_responseProperties {
    if (!self) {
        return nil;
    }
    NSDictionary *URLResponseDictionary = [super clue_responseProperties];
    NSMutableDictionary *responseDictionary = [[NSMutableDictionary alloc] initWithDictionary:URLResponseDictionary];
    [responseDictionary setObject:NSStringFromClass([self class]) forKey:@"class"];
    [responseDictionary setObject:@(self.statusCode) forKey:@"statusCode"];
    [responseDictionary setObject:[NSHTTPURLResponse localizedStringForStatusCode:self.statusCode]
                          forKey:@"localizedStringForStatusCode"];
    [responseDictionary clue_setValidObject:self.allHeaderFields forKey:@"allHeaderFields"];
    
    return responseDictionary;
}

@end
