//
//  CLUTextFieldViewRecordableAdditions.m
//  Clue
//
//  Created by Ahmed Sulaiman on 3/16/17.
//  Copyright © 2017 Ahmed Sulaiman. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "UITextField+CLUViewRecordableAdditions.h"

@interface CLUTextFieldViewRecordableAdditions : XCTestCase
@property (nonatomic) UITextField *testTextField;
@end

@implementation CLUTextFieldViewRecordableAdditions

- (void)setUp {
    [super setUp];
    _testTextField = [UITextField new];
    [_testTextField setFrame:CGRectMake(0, 0, 100, 100)];
    [_testTextField setBackgroundColor:[UIColor redColor]];
    
    [_testTextField setText:@"Test Text Content"];
    [_testTextField setPlaceholder:@"Test Placeholder Content"];
    [_testTextField setFont:[UIFont systemFontOfSize:13]];
    [_testTextField setTextColor:[UIColor redColor]];
    [_testTextField setMinimumFontSize:12];
    [_testTextField setBorderStyle:UITextBorderStyleNone];
}

- (void)tearDown {
    _testTextField = nil;
    [super tearDown];
}

- (void)testSubviewsSubDictionary {
    // Test Text Field View Property Dictionary
    NSDictionary *textFieldDictionary = [_testTextField clue_viewPropertiesDictionary];
    XCTAssertNotNil(textFieldDictionary, @"Text Field View Dictionary is invalid");
    XCTAssertEqual([textFieldDictionary count], 3, @"Text Field View Dictionary has wrong amount of items inside");
    
    // Tests Text Field View Subviews sub Dictionary
    NSDictionary *subviewsDictionary = [textFieldDictionary objectForKey:@"subviews"];
    XCTAssertNotNil(subviewsDictionary, @"Text Field View Dictionary has invalid subviews sub dictionary");
    XCTAssertEqual([subviewsDictionary count], 0, @"Text Field View properties sub dictionary has wrong amount of items inside");
}

- (void)testPropertiesSubDictionary {
    // Initialize test variables
    NSArray<NSString *> *testAllPropertiesKeys = @[@"frame", @"backgroundColor",
                                                   @"hidden", @"userInteractionEnabled",
                                                   @"layoutMargins", @"tag", @"focused",
                                                   @"text", @"attributedText",
                                                   @"placeholder", @"attributedPlaceholder",
                                                   @"font", @"textColor", @"minimumFontSize",
                                                   @"editing", @"borderStyle"];
    
    // Test Text Field View Property Dictionary
    NSDictionary *textFieldDictionary = [_testTextField clue_viewPropertiesDictionary];
    XCTAssertNotNil(textFieldDictionary, @"Text Field View Dictionary is invalid");
    XCTAssertEqual([textFieldDictionary count], 3, @"Text Field View Dictionary has wrong amount of items inside");
    
    // Test Text Field View Propeties sub Dictionary
    NSDictionary *propertiesDictionary = [textFieldDictionary objectForKey:@"properties"];
    XCTAssertNotNil(propertiesDictionary, @"Text Field View Dictionary has invalid properties sub dictionary");
    XCTAssertEqual([propertiesDictionary count], [testAllPropertiesKeys count],
                   @"Text Field View properties sub dictionary has wrong amount of items inside");
    
    // Tests keysa and values in Image View Propeties sub Dictionary
    for (NSString *currentTestKey in testAllPropertiesKeys) {
        NSObject *objectForKey = [propertiesDictionary objectForKey:currentTestKey];
        XCTAssertNotNil(objectForKey, @"Object for key:%@ is invalid in Text Field View properties sub dictionary", currentTestKey);
    }
}

- (void)testClassName {
    // Test Text Field View Property Dictionary
    NSDictionary *textFieldDictionary = [_testTextField clue_viewPropertiesDictionary];
    XCTAssertNotNil(textFieldDictionary, @"Text Field View Dictionary is invalid");
    XCTAssertEqual([textFieldDictionary count], 3, @"Text Field View Dictionary has wrong amount of items inside");
    
    // Tests Text Field View class name
    NSString *className = [textFieldDictionary objectForKey:@"class"];
    XCTAssertNotNil(className, @"Text Field Dictionary has invalid class value");
    XCTAssertTrue([className isEqualToString:@"UITextField"], @"Text Field Dictionary has wrong class name");
}

@end
