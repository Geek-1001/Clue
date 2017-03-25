//
//  NSError+CLUNetworkAdditions.h
//  Clue
//
//  Created by Ahmed Sulaiman on 6/23/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 `NSError (CLUNetworkAdditions)` category contains method to parse `NSError` properties and encode them into json like dictionary
 To be able to include `NSError` properties into Clue report (mostly for Network module)
*/
@interface NSError (CLUNetworkAdditions)

/**
 Generate error dictionary which includes error class name, code, domain, userInfo, localizedDescription and localizedFailureReason for current `NSError` object
 
 @warning This method doesn't have any input, it generates dictionary based on current `NSError` object
 
 @return Error dictionary with data from current `NSError` object
 
 @code {
    "class" : <NSString>,
    "code" : <NSNumber>,
    "domain" : <NSString>,
    "userInfo" : <NSDictionary>,
    "localizedDescription" : <NSString>,
    "localizedFailureReason" : <NSString>
 }
*/
- (NSDictionary *)clue_errorProperties;

@end
