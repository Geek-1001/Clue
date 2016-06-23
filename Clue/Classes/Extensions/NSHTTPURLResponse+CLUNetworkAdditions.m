//
//  NSHTTPURLResponse+CLUNetworkAdditions.m
//  Clue
//
//  Created by Ahmed Sulaiman on 6/23/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import "NSHTTPURLResponse+CLUNetworkAdditions.h"
#import "NSURLResponse+CLUNetworkAdditions.h"

@implementation NSHTTPURLResponse (CLUNetworkAdditions)

- (NSDictionary *)clue_responseProperties {
    if (!self) {
        return nil;
    }
    NSDictionary *URLResponseDictionary = [super clue_responseProperties];
    NSMutableDictionary *responseDictionary = [[NSMutableDictionary alloc] initWithDictionary:URLResponseDictionary];
    [responseDictionary setValue:NSStringFromClass([self class]) forKey:@"class"];
    [responseDictionary setValue:[NSNumber numberWithInteger:self.statusCode] forKey:@"statusCode"];
    [responseDictionary setValue:[NSHTTPURLResponse localizedStringForStatusCode:self.statusCode]
                          forKey:@"localizedStringForStatusCode"];
    [responseDictionary setValue:self.allHeaderFields forKey:@"allHeaderFields"];
    
    return responseDictionary;
}

@end
