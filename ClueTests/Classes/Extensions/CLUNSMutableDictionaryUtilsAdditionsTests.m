//
//  CLUNSMutableDictionaryUtilsAdditionsTests.m
//  Clue
//
//  Created by Ahmed Sulaiman on 4/21/17.
//  Copyright © 2017 Ahmed Sulaiman. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSMutableDictionary+CLUUtilsAdditions.h"

@interface CLUNSMutableDictionaryUtilsAdditionsTests : XCTestCase

@end

@implementation CLUNSMutableDictionaryUtilsAdditionsTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testSetValidObjectForKey_ValidObject {
    NSMutableDictionary *dictionary = [NSMutableDictionary new];
    XCTAssertNotNil(dictionary, @"Dictionary should be valid");
    XCTAssertEqual(dictionary.count, 0, @"Dictionary should be empty");
    
    NSString *testValidObject = @"valid-string-object";
    [dictionary clue_setValidObject:testValidObject forKey:@"key"];
    
    XCTAssertEqual(dictionary.count, 1, @"Dictionary should contain 1 object");
    XCTAssertEqualObjects([dictionary objectForKey:@"key"], testValidObject,
                          @"Dictionary should contain same test valid object");
}

- (void)testSetValidObjectForKey_InvalidObject {
    NSMutableDictionary *dictionary = [NSMutableDictionary new];
    XCTAssertNotNil(dictionary, @"Dictionary should be valid");
    XCTAssertEqual(dictionary.count, 0, @"Dictionary should be empty");
    
    [dictionary clue_setValidObject:nil forKey:@"key"];
    
    XCTAssertEqual(dictionary.count, 0,
    @"Dictionary should still be empty because new object was invalid");
}

- (void)testSetFilteredObjectForKeyWithFilterBlock {
    NSMutableDictionary *dictionary = [NSMutableDictionary new];
    XCTAssertNotNil(dictionary, @"Dictionary should be valid");
    XCTAssertEqual(dictionary.count, 0, @"Dictionary should be empty");
    
    NSString *testObject = @"short-string"; // 12 symbols length
    [dictionary clue_setFilteredObject:testObject forKey:@"key" withFilterBlock:^BOOL(id  _Nullable object) {
        NSString *stringObject = (NSString *) object;
        if (stringObject == nil) {
            return NO;
        }
        if (stringObject.length < 15) {
            return NO;
        } else {
            return YES;
        }
    }];
    
    XCTAssertEqual(dictionary.count, 0,
    @"Dictionary should still be empty because new object isn't confirms to filter's conditions");
}

@end
