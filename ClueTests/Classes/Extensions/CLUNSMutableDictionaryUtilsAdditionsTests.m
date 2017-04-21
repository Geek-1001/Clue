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

@end
