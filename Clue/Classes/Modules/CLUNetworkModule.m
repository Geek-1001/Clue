//
//  CLUNetworkModule.m
//  Clue
//
//  Created by Ahmed Sulaiman on 6/23/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import "CLUNetworkModule.h"
#import "CLUDataWriter.h"
#import "CLUURLProtocol.h"

@implementation CLUNetworkModule

- (void)startRecording {
    if (!self.isRecording) {
        [super startRecording];
        [NSURLProtocol registerClass:[CLUURLProtocol class]];
        [[CLUURLProtocolConfiguration sharedConfiguration] setNetworkObserverDelegate:self];
    }
}

- (void)stopRecording {
    if (self.isRecording) {
        [super stopRecording];
        [NSURLProtocol unregisterClass:[CLUURLProtocol class]];
        [[CLUURLProtocolConfiguration sharedConfiguration] removeNetworkObserverDelegate];
    }
}

#pragma mark - Network Observer Delegate

- (void)networkRequestDidCompleteWithError:(NSError *)error {
    
}

- (void)networkRequestDidRedirectWithResponse:(NSHTTPURLResponse *)response newRequest:(NSURLRequest *)request {
    
}

- (void)networkRequestDidReceiveData:(NSData *)data {
    
}

- (void)networkRequestDidReceiveResponse:(NSURLResponse *)response {
    
}

@end
