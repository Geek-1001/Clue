//
//  NSHTTPURLResponse+CLUNetworkAdditions.h
//  Clue
//
//  Created by Ahmed Sulaiman on 6/23/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSHTTPURLResponse (CLUNetworkAdditions)

- (NSDictionary *)clue_responseProperties;

@end
