//
//  CLULabelRecordableAdditions.m
//  Clue
//
//  Created by Ahmed Sulaiman on 3/16/17.
//  Copyright © 2017 Ahmed Sulaiman. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "UILabel+CLUViewRecordableAdditions.h"

@interface CLULabelRecordableAdditions : XCTestCase
@property (nonatomic) UILabel *testLabel;
@end

@implementation CLULabelRecordableAdditions

- (void)setUp {
    [super setUp];
    _testLabel = [UILabel new];
    
    [_testLabel setFrame:CGRectMake(0, 0, 100, 100)];
    [_testLabel setBackgroundColor:[UIColor redColor]];
    [_testLabel setLayoutMargins:UIEdgeInsetsMake(10, 10, 10, 10)];
    [_testLabel setHidden:NO];
    [_testLabel setUserInteractionEnabled:YES];
    [_testLabel setTag:1];
    
    [_testLabel setText:@"Test Label Content"];
    [_testLabel setFont:[UIFont systemFontOfSize:13]];
    [_testLabel setTextColor:[UIColor whiteColor]];
    [_testLabel setShadowColor:[UIColor blackColor]];
    [_testLabel setShadowOffset:CGSizeMake(10, 10)];
    [_testLabel setHighlighted:YES];
    [_testLabel setNumberOfLines:2];
    [_testLabel setLineBreakMode:NSLineBreakByCharWrapping];
}

- (void)tearDown {
    _testLabel = nil;
    [super tearDown];
}

- (void)testViewPropertyDictionary {
    // Initialize test variables
    NSArray<NSString *> *testAllPropertiesKeys = @[@"frame", @"backgroundColor",
                                                   @"hidden", @"userInteractionEnabled",
                                                   @"layoutMargins", @"tag", @"focused",
                                                   @"text", @"attributedText", @"font",
                                                   @"textColor", @"enabled", @"lineBreakMode",
                                                   @"numberOfLines", @"highlighted",
                                                   @"shadowColor", @"shadowOffset"];
    
    // Test Label View Property Dictionary
    NSDictionary *labelDictionary = [_testLabel clue_viewPropertiesDictionary];
    XCTAssertNotNil(labelDictionary, @"Label View Dictionary is invalid");
    XCTAssertEqual([labelDictionary count], 3, @"Label View Dictionary has wrong amount of items inside");
    
    // Test Label View Propeties sub Dictionary
    NSDictionary *propertiesDictionary = [labelDictionary objectForKey:@"properties"];
    XCTAssertNotNil(propertiesDictionary, @"Label Dictionary has invalid properties sub dictionary");
    XCTAssertEqual([propertiesDictionary count], [testAllPropertiesKeys count], @"Label properties sub dictionary has wrong amount of items inside");
    
    // Tests keysa and values in Label View Propeties sub Dictionary
    for (NSString *currentTestKey in testAllPropertiesKeys) {
        NSObject *objectForKey = [propertiesDictionary objectForKey:currentTestKey];
        XCTAssertNotNil(objectForKey, @"Object for key:%@ is invalid in Label properties sub dictionary", currentTestKey);
    }
    
    // Tests Label Subviews sub Dictionary
    NSDictionary *subviewsDictionary = [labelDictionary objectForKey:@"subviews"];
    XCTAssertNotNil(subviewsDictionary, @"Label Dictionary has invalid subviews sub dictionary");
    XCTAssertEqual([subviewsDictionary count], 0, @"Label properties sub dictionary has wrong amount of items inside");
    
    // Tests Label class name
    NSString *className = [labelDictionary objectForKey:@"class"];
    XCTAssertNotNil(className, @"Label Dictionary has invalid class value");
    XCTAssertTrue([className isEqualToString:@"UILabel"], @"Label Dictionary has wrong class name");
}

@end
