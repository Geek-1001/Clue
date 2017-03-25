//
//  NSHTTPURLResponse+CLUNetworkAdditions.h
//  Clue
//
//  Created by Ahmed Sulaiman on 6/23/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 `NSHTTPURLResponse (CLUNetworkAdditions)` category contains method to parse `NSHTTPURLResponse` properties and encode them into json like dictionary
 To be able to include `NSHTTPURLResponse` properties into Clue report (for Network module)

 Specifically method `[NSHTTPURLResponse clue_responseProperties]` use parent's implementation to get basic response properties (NSHTTPURLResponse subclass of NSURLResponse) and add some `NSHTTPURLResponse` specific properties and return full dictionary
*/
@interface NSHTTPURLResponse (CLUNetworkAdditions)

/**
 Generate HTTP URL response dictionary which includes properties from URL Response and statusCode, localizedStringForStatusCode, allHeaderFields for current `NSHTTPURLResponse` object
 
 @warning This method doesn't have any input, it generates dictionary based on current `NSHTTPURLResponse` object
 
 @return HTTP URL response dictionary with data from current `NSHTTPURLResponse` object
 
 @code {
    "class" : <NSString>,
    "MIMEType" : <NSString>,
    "URL" : <NSString>,
    "expectedContentLength" : <NSNumber>,
    "statusCode" : <NSNumber>,
    "localizedStringForStatusCode" : <NSString>,
    "allHeaderFields" : <NSDictionary>
 }
*/
- (NSDictionary *)clue_responseProperties;

@end
