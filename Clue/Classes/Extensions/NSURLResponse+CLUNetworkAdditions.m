//
//  NSURLResponse+CLUNetworkAdditions.m
//  Clue
//
//  Created by Ahmed Sulaiman on 6/23/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import "NSURLResponse+CLUNetworkAdditions.h"

@implementation NSURLResponse (CLUNetworkAdditions)

- (NSDictionary *)clue_responseProperties {
    if (!self) {
        return nil;
    }
    NSMutableDictionary *responseProperties = [[NSMutableDictionary alloc] init];
    [responseProperties setValue:self.MIMEType forKey:@"MIMEType"];
    [responseProperties setValue:self.URL forKey:@"URL"];
    [responseProperties setValue:[NSNumber numberWithLong:self.expectedContentLength] forKey:@"expectedContentLength"];
    
    return responseProperties;
}

@end
