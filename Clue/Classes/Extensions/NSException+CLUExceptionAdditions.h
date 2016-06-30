//
//  NSException+CLUExceptionAdditions.h
//  Clue
//
//  Created by Ahmed Sulaiman on 6/30/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSException (CLUExceptionAdditions)

- (NSDictionary *)clue_exceptionProperties;

@end
