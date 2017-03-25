//
//  CLUNetworkModule.h
//  Clue
//
//  Created by Ahmed Sulaiman on 6/23/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import "CLUObserveModule.h"
#import "CLUNetworkObserverDelegate.h"

/**
 `CLUNetworkModule` is a subclass of `CLUObserveModule` for network operations recording (like responses, requests and errors) for any specific time. It will listen for all network operations via custom `NSURLProtocol` subclass (see `CLUURLProtocol`) and `CLUURLProtocol` will send them to `CLUNetworkObserverDelegate` methods so `CLUNetworkModule` can add this data to buffer with specific timestamp
 */
@interface CLUNetworkModule : CLUObserveModule <CLUNetworkObserverDelegate>

@end
