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
#import "NSError+CLUNetworkAdditions.h"
#import "NSURLResponse+CLUNetworkAdditions.h"
#import "NSHTTPURLResponse+CLUNetworkAdditions.h"
#import "NSURLRequest+CLUNetworkAdditions.h"
#import "NSMutableDictionary+CLUUtilsAdditions.h"

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

#pragma mark Parser for Network objects

- (void)addNetworkOperationToBufferWithLabel:(nonnull NSString *)label properties:(nullable NSArray<NSDictionary *> *)properties {
    @synchronized (self) {
        NSMutableDictionary *networkDictionary = [[NSMutableDictionary alloc] init];
        [networkDictionary setObject:@(self.currentTimeStamp) forKey:TIMESTAMP_KEY];
        [networkDictionary setObject:label forKey:@"label"];
        
        if (properties && [properties count] > 0) {
            [networkDictionary setObject:properties forKey:@"properties"];
        }
        
        if ([NSJSONSerialization isValidJSONObject:networkDictionary]) {
            NSError *error;
            NSData *networkData = [NSJSONSerialization dataWithJSONObject:networkDictionary options:0 error:&error];
            if (!error) {
                [self addData:networkData];
            }
        } else {
            NSLog(@"Network properties json is invalid");
        }
    }
}

#pragma mark - Network Observer Delegate

- (void)networkRequestDidCompleteWithError:(NSError *)error {
    NSDictionary *errorProperties;
    if (error) {
        errorProperties = [error clue_errorProperties];
    }
    [self addNetworkOperationToBufferWithLabel:@"DidComplete" properties:@[errorProperties]];
}

- (void)networkRequestDidRedirectWithResponse:(NSHTTPURLResponse *)response newRequest:(NSURLRequest *)request {
    NSDictionary *responseProperties = [response clue_responseProperties];
    NSDictionary *newRequestProperties = [request clue_requestProperties];
    [self addNetworkOperationToBufferWithLabel:@"DidRedirect" properties:@[responseProperties, newRequestProperties]];
}

- (void)networkRequestDidReceiveData:(NSData *)data {
    // TODO: think about better approach for NSData
    NSMutableDictionary *dataProperties = [[NSMutableDictionary alloc] init];
    NSString *bodyString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [dataProperties clue_setValidObject:bodyString forKey:@"HTTPBody"];
    [self addNetworkOperationToBufferWithLabel:@"DidReceiveData" properties:@[dataProperties]];
}

- (void)networkRequestDidReceiveResponse:(NSURLResponse *)response {
    NSDictionary *responseProperties = [response clue_responseProperties];
    [self addNetworkOperationToBufferWithLabel:@"DidReceiveResponse" properties:@[responseProperties]];
}

@end
