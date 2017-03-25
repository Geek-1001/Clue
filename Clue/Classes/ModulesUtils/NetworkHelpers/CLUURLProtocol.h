//
//  CLUURLProtocol.h
//  Clue
//
//  Created by Ahmed Sulaiman on 6/18/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLUNetworkObserverDelegate.h"

/**
 `CLUURLProtocol` is a subclass of abstract `NSURLProtocol` to intercept all network requests during report recording and redirect them to appropriate delegate method from `CLUNetworkObserverDelegate` using `CLUURLProtocolConfiguration` singleton class
 */
@interface CLUURLProtocol : NSURLProtocol <NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDataDelegate>

@end

/**
 `CLUURLProtocolConfiguration` is a singleton class which keeps custom network configuration (like `CLUNetworkObserverDelegate` delegate) 
 Used for additional configuration of `CLUURLProtocol` which intercepting all network communication.
 */
@interface CLUURLProtocolConfiguration : NSObject

/**
 Delegate instance of `CLUNetworkObserverDelegate` to be able to redirect network communication from `CLUURLProtocol` to appropriate delegate method
 */
@property (nonatomic, readonly, strong, getter = networkDelegate) id <CLUNetworkObserverDelegate> delegate;

/**
 Returns the shared singleton instance of `CLUURLProtocolConfiguration`

 @return Shared singleton instance of `CLUURLProtocolConfiguration`
 */
+ (instancetype)sharedConfiguration;

/**
 Set `CLUNetworkObserverDelegate` delegate object

 @param delegate Delegate instance of `CLUNetworkObserverDelegate` to be able to redirect network communication from `CLUURLProtocol` to appropriate delegate method
 
 @warning Always call `-removeNetworkObserverDelegate` when you don't need network delegate anymore
 */
- (void)setNetworkObserverDelegate:(id <CLUNetworkObserverDelegate>)delegate;

/**
 Remove `CLUNetworkObserverDelegate` delegate object
 */
- (void)removeNetworkObserverDelegate;

@end
