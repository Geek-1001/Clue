//
//  CLUNetworkObserverDelegate.h
//  Clue
//
//  Created by Ahmed Sulaiman on 6/18/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 `CLUNetworkObserverDelegate` protocol describe delegate methods which will handle all network operations events sent by custom `NSURLProtocol` (see `CLUURLProtocol` and `CLUURLProtocolConfiguration`)
 */
@protocol CLUNetworkObserverDelegate <NSObject>

@required

/**
 Tells current delegate object that some network request was redirected
 
 @param response Actual `NSHTTPURLResponse` response from redirected network request
 @param request New `NSURLRequest` request (redirect from old request to new one)
 */
- (void)networkRequestDidRedirectWithResponse:(nonnull NSHTTPURLResponse *)response newRequest:(nonnull NSURLRequest *)request;

/**
 Tells current delegate object that some network request did complete with specific `NSError` error
 
 @param error `NSError` error object which should explain why network request failed
 */
- (void)networkRequestDidCompleteWithError:(nullable NSError *)error;

/**
 Tells current delegate object that network request did receive `NSURLResponse` response

 @param response `NSURLResponse` response for some network request sent earlier
 */
- (void)networkRequestDidReceiveResponse:(nonnull NSURLResponse *)response;

/**
 Tells current delegate object that network request did receive `NSData` data

 @param data `NSData` data for some network request sent earlier
 */
- (void)networkRequestDidReceiveData:(nonnull NSData *)data;

@end
