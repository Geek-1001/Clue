//
//  NSURLRequest+CLUNetworkAdditions.h
//  Clue
//
//  Created by Ahmed Sulaiman on 6/23/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 `NSURLRequest (CLUNetworkAdditions)` category contains method to parse `NSURLRequest` properties and encode them into json like dictionary
 To be able to include `NSURLRequest` properties into Clue report (for Network module)
*/
@interface NSURLRequest (CLUNetworkAdditions)

/**
 Generate URL request dictionary which includes class name, URL, allHTTPHeaderFields, HTTPMethod, HTTPShouldHandleCookies and HTTPBody for current `NSURLRequest` object
 
 @warning This method doesn't have any input, it generates dictionary based on current `NSURLRequest` object
 
 @return URL Request dictionary with data from current `NSURLRequest` object
 
 @code {
    "class" : <NSString>,
    "URL" : <NSString>,
    "allHTTPHeaderFields" : <NSDictionary>,
    "HTTPMethod" : <NSString>,
    "HTTPShouldHandleCookies" : <NSNumber>,
    "HTTPBody" : <NSString>
 }
*/
- (NSDictionary *)clue_requestProperties;

@end
