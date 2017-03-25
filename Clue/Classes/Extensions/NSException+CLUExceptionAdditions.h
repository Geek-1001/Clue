//
//  NSException+CLUExceptionAdditions.h
//  Clue
//
//  Created by Ahmed Sulaiman on 6/30/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 `NSException (CLUExceptionAdditions)` category contains method to parse `NSException` properties and encode them into json like dictionary
 To be able to include `NSException` properties into Clue report (to handle unexpected exception during report recording)
*/
@interface NSException (CLUExceptionAdditions)

/**
 Generate exception dictionary which includes name, reason, userInfo, callStackReturnAddresses and callStackSymbols for current `NSException` object
 
 @warning This method doesn't have any input, it generates dictionary based on current `NSException` object
 
 @return Exception dictionary with data from current `NSException` object
 
 @code {
 "name" : <NSString>,
 "reason" : <NSString>,
 "userInfo" : <NSDictionary>,
 "callStackReturnAddresses" : <NSArray <NSNumber>>
 "callStackSymbols" : <NSArray <NSString>>
 }
*/
- (NSDictionary *)clue_exceptionProperties;

@end
