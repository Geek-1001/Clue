//
//  NSURLResponse+CLUNetworkAdditions.h
//  Clue
//
//  Created by Ahmed Sulaiman on 6/23/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 `NSURLResponse (CLUNetworkAdditions)` category contains method to parse `NSURLResponse` properties and encode them into json like dictionary
 To be able to include `NSURLResponse` properties into Clue report (for Network module)
*/
@interface NSURLResponse (CLUNetworkAdditions)

/**
 Generate URL response dictionary which includes class name, MIME type, URL and expectedContentLength for current `NSURLResponse` object
 
 @warning This method doesn't have any input, it generates dictionary based on current `NSURLResponse` object
 
 @return URL response dictionary with data from current `NSURLResponse` object
 
 @code {
    "class" : <NSString>,
    "MIMEType" : <NSString>,
    "URL" : <NSString>,
    "expectedContentLength" : <NSNumber>
 }
*/
- (NSDictionary *)clue_responseProperties;

@end
