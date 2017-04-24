//
//  CLUCommunicationNetworkAdditions.m
//  Clue
//
//  Created by Ahmed Sulaiman on 3/16/17.
//  Copyright © 2017 Ahmed Sulaiman. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSURLResponse+CLUNetworkAdditions.h"
#import "NSHTTPURLResponse+CLUNetworkAdditions.h"
#import "NSURLRequest+CLUNetworkAdditions.h"

@interface CLUCommunicationNetworkAdditions : XCTestCase
@property (nonatomic) NSURL *testURL;
@end

@implementation CLUCommunicationNetworkAdditions

- (void)setUp {
    [super setUp];
    _testURL = [NSURL URLWithString:@"test-url"];
}

- (void)tearDown {
    _testURL = nil;
    [super tearDown];
}

- (void)testURLRequestProperty {
    // Initialize test variables
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:_testURL];
    request.allHTTPHeaderFields = @{@"test-header-name" : @"test-header-value"};
    request.HTTPMethod = @"GET";
    request.HTTPBody = [@"test-body" dataUsingEncoding:NSUTF8StringEncoding];
    request.HTTPShouldHandleCookies = YES;
    NSDictionary *testRequestDictionary = @{@"class" : @"NSMutableURLRequest",
                                            @"URL" : @"test-url",
                                            @"allHTTPHeaderFields" : @{@"test-header-name" : @"test-header-value"},
                                            @"HTTPMethod" : @"GET",
                                            @"HTTPShouldHandleCookies" : @(YES),
                                            @"HTTPBody" : @"test-body"};
    
    // Test Request Property Dictionary
    NSDictionary *requestDictionary = [request clue_requestProperties];
    XCTAssertNotNil(requestDictionary, @"Request Dictionary is invalid");
    XCTAssertTrue([requestDictionary isEqualToDictionary:testRequestDictionary], @"Request Dictionary is not equal to test data");
}

- (void)testHTTPURLResponseProperty {
    // Initialize test variables
    NSHTTPURLResponse *response = [[NSHTTPURLResponse alloc] initWithURL:_testURL
                                                              statusCode:201
                                                             HTTPVersion:@"1.0"
                                                            headerFields:@{@"test-header-name" : @"test-header-value"}];
    NSDictionary *testResponseDictionary = @{@"class" : @"NSHTTPURLResponse",
                                             @"URL" : @"test-url",
                                             @"expectedContentLength" : @(-1), // if no expected content length
                                             @"statusCode" : @(201),
                                             @"localizedStringForStatusCode" : @"created",
                                             @"allHeaderFields" : @{@"test-header-name" : @"test-header-value"}};

    // Test HTTP URL Response Property Dictionry
    NSDictionary *responseDictionary = [response clue_responseProperties];
    XCTAssertNotNil(responseDictionary, @"HTTP URL Response dictionary is invalid");
    XCTAssertTrue([responseDictionary isEqualToDictionary:testResponseDictionary],
                  @"HTTP URL Response dictionary is not equal to test data");
}

- (void)testURLResponseProperty {
    // Initialize test variables
    NSURLResponse *response = [[NSURLResponse alloc] initWithURL:_testURL
                                                        MIMEType:@"test-mime"
                                           expectedContentLength:20
                                                textEncodingName:nil];
    NSDictionary *testResponseDictionary = @{@"class" : @"NSURLResponse",
                                             @"MIMEType" : @"test-mime",
                                             @"URL" : @"test-url",
                                             @"expectedContentLength" : @(20)};
    
    // Test URL Response Dictionary
    NSDictionary *responseDictionary = [response clue_responseProperties];
    XCTAssertNotNil(responseDictionary, @"URL Response dictionary is invalid");
    XCTAssertTrue([responseDictionary isEqualToDictionary:testResponseDictionary], @"URL Reponse dictionary is not equal to test data");
}

@end
