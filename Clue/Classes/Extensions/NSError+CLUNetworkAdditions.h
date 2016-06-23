//
//  NSError+CLUNetworkAdditions.h
//  Clue
//
//  Created by Ahmed Sulaiman on 6/23/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (CLUNetworkAdditions)

- (NSDictionary *)clue_errorProperties;

@end
