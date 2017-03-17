//
//  CLUErrorNetworkAdditions.m
//  Clue
//
//  Created by Ahmed Sulaiman on 3/16/17.
//  Copyright © 2017 Ahmed Sulaiman. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSError+CLUNetworkAdditions.h"

@interface CLUErrorNetworkAdditions : XCTestCase

@end

@implementation CLUErrorNetworkAdditions

- (void)testErrorProperties {
    // Initialize test variables
    NSError *testError = [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:123
                                         userInfo:nil];
    NSArray<NSString *> *testAllKeys = @[@"class", @"code", @"domain",
                                         @"userInfo", @"localizedDescription",
                                         @"localizedFailureReason"];
    
    // Test error dictionary
    NSDictionary *errorDictionary = [testError clue_errorProperties];
    XCTAssertNotNil(errorDictionary, @"Error Dictionary is invalid");
    XCTAssertEqual([errorDictionary count], [testAllKeys count], @"Error dictionary has wrong amount of items");
    
    // Test keys for error dictionary
    for (NSString *currentTestKey in testAllKeys) {
        NSObject *objectForKey = [errorDictionary objectForKey:currentTestKey];
        XCTAssertNotNil(objectForKey, @"Objectf or key:%@ is incorrect", currentTestKey);
    }
}

@end
