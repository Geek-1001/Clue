//
//  CLUURLProtocol.m
//  Clue
//
//  Created by Ahmed Sulaiman on 6/18/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import "CLUURLProtocol.h"

@interface CLUURLProtocol()

@property (nonatomic, readwrite, strong) NSURLSessionDataTask *dataTask;
@property (nonatomic, readwrite, strong) NSURLSession *session;

@end

@implementation CLUURLProtocol

#pragma mark - NSURLProtocol Methods

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    BOOL isAccept = ([[[request URL] scheme] isEqualToString:@"http"] || [[[request URL] scheme] isEqualToString:@"https"]);
    return isAccept;
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    // Just return same request. We don't need to modify it. Just intercept and add to report
    return request;
}

- (instancetype)initWithRequest:(NSURLRequest *)request cachedResponse:(NSCachedURLResponse *)cachedResponse client:(id<NSURLProtocolClient>)client {
    self = [super initWithRequest:request cachedResponse:cachedResponse client:client];
    if (!self) {
        return nil;
    }
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    _session = [NSURLSession sessionWithConfiguration:sessionConfiguration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    return self;
}

- (void)startLoading {
    _dataTask = [_session dataTaskWithRequest:self.request];
    [_dataTask resume];
}

- (void)stopLoading {
    // Leave it empty for now.
}

#pragma mark - NSURLSession Delegate

- (void)URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler {
    [[self client] URLProtocol:self didReceiveAuthenticationChallenge:challenge];
}

#pragma mark - NSURLSession Task Delegate

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    if (error) {
        [[self client] URLProtocol:self didFailWithError:error];
    } else {
        [[self client] URLProtocolDidFinishLoading:self];
    }
}

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler {
    [[self client] URLProtocol:self didReceiveAuthenticationChallenge:challenge];
}

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
willPerformHTTPRedirection:(NSHTTPURLResponse *)response
        newRequest:(NSURLRequest *)request
 completionHandler:(void (^)(NSURLRequest * _Nullable))completionHandler {
    [[self client] URLProtocol:self wasRedirectedToRequest:request redirectResponse:response];
}

#pragma mark - NSURLSession Data Delegate

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
    [[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageAllowedInMemoryOnly];
    if (completionHandler) {
        completionHandler(NSURLSessionResponseAllow);
    }
}

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data {
    [[self client] URLProtocol:self didLoadData:data];
}

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
 willCacheResponse:(NSCachedURLResponse *)proposedResponse
 completionHandler:(void (^)(NSCachedURLResponse *cachedResponse))completionHandler {
    [[self client] URLProtocol:self cachedResponseIsValid:proposedResponse];
}

@end
