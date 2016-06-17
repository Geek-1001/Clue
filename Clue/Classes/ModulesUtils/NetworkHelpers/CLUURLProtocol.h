//
//  CLUURLProtocol.h
//  Clue
//
//  Created by Ahmed Sulaiman on 6/18/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLUNetworkObserverDelegate.h"

@interface CLUURLProtocol : NSURLProtocol <NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDataDelegate>

@end

@interface CLUURLProtocolConfiguration : NSObject

@property (nonatomic, readonly, strong, getter = networkDelegate) id <CLUNetworkObserverDelegate> delegate;

+ (instancetype)sharedConfiguration;
- (void)setNetworkObserverDelegate:(id <CLUNetworkObserverDelegate>)delegate;
- (void)removeNetworkObserverDelegate;

@end
