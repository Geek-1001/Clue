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
    XCTAssertTrue([exceptionDictionary isEqualToDictionary:testExceptionDictionary], @"Exception dictionary is not equal to test data");
}

@end
