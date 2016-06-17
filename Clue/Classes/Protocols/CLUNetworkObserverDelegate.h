//
//  CLUNetworkObserverDelegate.h
//  Clue
//
//  Created by Ahmed Sulaiman on 6/18/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CLUNetworkObserverDelegate <NSObject>

@required
- (void)networkRequestDidRedirectWithResponse:(NSHTTPURLResponse *)response newRequest:(NSURLRequest *)request;
- (void)networkRequestDidCompleteWithError:(NSError *)error;
- (void)networkRequestDidReceiveResponse:(NSURLResponse *)response;
- (void)networkRequestDidReceiveData:(NSData *)data;

@end
