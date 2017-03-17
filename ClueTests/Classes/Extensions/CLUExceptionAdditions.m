//
//  CLUExceptionAdditions.m
//  Clue
//
//  Created by Ahmed Sulaiman on 3/17/17.
//  Copyright © 2017 Ahmed Sulaiman. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSException+CLUExceptionAdditions.h"

@interface CLUExceptionAdditions : XCTestCase

@end

@implementation CLUExceptionAdditions

- (void)testExceptionProperty {
    // Initialize test variables
    NSException *exception = [[NSException alloc] initWithName:NSInvalidArgumentException
                                                        reason:@"Agruments are invalid"
                                                      userInfo:@{@"argumentName" : @"test-argument"}];
    NSDictionary *testExceptionDictionary = @{@"name" : @"NSInvalidArgumentException",
                                              @"reson" : @"Agruments are invalid",
                                              @"userInfo" : @{@"argumentName" : @"test-argument"},
                                              @"callStackReturnAddresses" : @"",
                                              @"callStackSymbols" : @""};
    
    // Test Exception Property dictionary
    NSDictionary *exceptionDictionary = [exception clue_exceptionProperties];
    XCTAssertNotNil(exceptionDictionary, @"Exception dictionary is invalid");
    XCTAssertEqual([exceptionDictionary count], [testExceptionDictionary count], @"Exception dictionary has wrong amount of items");
    
    // Test keys and values in Exception Dictionary
    for (NSString *currentTestKey in testExceptionDictionary.allKeys) {
        NSObject *testObject = [testExceptionDictionary objectForKey:currentTestKey];
        
        NSObject *objectForKey = [exceptionDictionary objectForKey:currentTestKey];
        XCTAssertNotNil(objectForKey, @"Object for key:%@ is invalid in Exception dictionary", currentTestKey);
        XCTAssertEqualObjects(objectForKey, testObject, @"Object for key:%@ is incorrect in Exception dictionary", currentTestKey);
    }
}

@end
