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
@property (nonatomic) NSMutableDictionary *dictionary;
@end

@implementation CLUNSMutableDictionaryUtilsAdditionsTests

- (void)setUp {
    [super setUp];
    _dictionary = [NSMutableDictionary new];
}

- (void)tearDown {
    _dictionary = nil;
    [super tearDown];
}

- (void)testSetValidObjectForKey_ValidObject {
    NSString *testValidObject = @"valid-string-object";
    [_dictionary clue_setValidObject:testValidObject forKey:@"key"];
    
    XCTAssertEqual(_dictionary.count, 1, @"Dictionary should contain 1 object");
    XCTAssertEqualObjects([_dictionary objectForKey:@"key"], testValidObject,
                          @"Dictionary should contain same test valid object");
}

- (void)testSetValidObjectForKey_InvalidObject {
    [_dictionary clue_setValidObject:nil forKey:@"key"];
    
    XCTAssertEqual(_dictionary.count, 0,
    @"Dictionary should still be empty because new object was invalid");
}

- (void)testSetFilteredObjectForKeyWithFilterBlock {
    NSString *testObject = @"short-string"; // 12 symbols length
    [_dictionary clue_setFilteredObject:testObject forKey:@"key" withFilterBlock:^BOOL(id  _Nullable object) {
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

    XCTAssertEqual(_dictionary.count, 0,
    @"Dictionary should still be empty because new object isn't confirms to filter's conditions");
}

- (void)testSetValidAndNotEmptyString_EmptyString {
    NSString *testString = @"";
    [_dictionary clue_setValidAndNotEmptyString:testString forKey:@"key"];
    
    XCTAssertNil([_dictionary objectForKey:@"key"], @"There should be no empty string in this dictionary");
}

- (void)testSetValidAndNotEmptyString_InvalidString {
    [_dictionary clue_setValidAndNotEmptyString:nil forKey:@"key"];
    
    XCTAssertNil([_dictionary objectForKey:@"key"], @"There should be no invalid string in this dictionary");
}

- (void)testSetValidAndNotEmptyString_ValidNotEmptyString {
    NSString *testString = @"string";
    [_dictionary clue_setValidAndNotEmptyString:testString forKey:@"key"];
    
    XCTAssertNotNil([_dictionary objectForKey:@"key"], @"There should be valid string in this dictionary");
}

- (void)testSetValidAndNotEmptyDictionary_EmptyDictionary {
    NSDictionary *testDictionary = [NSDictionary new];
    [_dictionary clue_setValidAndNotEmptyDictionary:testDictionary forKey:@"key"];
    
    XCTAssertNil([_dictionary objectForKey:@"key"], @"There should be no empty dictionary in this dictionary");
}

- (void)testSetValidAndNotEmptyDictionary_InvalidDictionary {
    [_dictionary clue_setValidAndNotEmptyDictionary:nil forKey:@"key"];
    
    XCTAssertNil([_dictionary objectForKey:@"key"], @"There should be no invalid dictionary in this dictionary");
}

- (void)testSetValidAndNotEmptyDictionary_ValidNotEmptyDictionary {
    NSDictionary *testDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:@"object", @"key", nil];
    [_dictionary clue_setValidAndNotEmptyDictionary:testDictionary forKey:@"key"];
    
    XCTAssertNotNil([_dictionary objectForKey:@"key"], @"There should be valid dictionary in this dictionary");
}

- (void)testSetValidAndNotEmptyArray_EmptyArray {
    NSArray *testArray = [NSArray new];
    [_dictionary clue_setValidAndNotEmptyArray:testArray forKey:@"key"];
    
    XCTAssertNil([_dictionary objectForKey:@"key"], @"There should be no empty array in this dictionary");
}

- (void)testSetValidAndNotEmptyArray_InvalidArray {
    [_dictionary clue_setValidAndNotEmptyArray:nil forKey:@"key"];
    
    XCTAssertNil([_dictionary objectForKey:@"key"], @"There should be no invalid array in this dictionary");
}

- (void)testSetValidAndNotEmptyArray_ValidAndNotEmptyArray {
    NSArray *testArray = [[NSArray alloc] initWithObjects:@"test-object-1", @"test-object-2", nil];
    [_dictionary clue_setValidAndNotEmptyArray:testArray forKey:@"key"];
    
    XCTAssertNotNil([_dictionary objectForKey:@"key"], @"There should be valid and not emoty array in this dictionary");
}

@end
