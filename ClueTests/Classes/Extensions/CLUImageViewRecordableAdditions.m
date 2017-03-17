//
//  CLUImageViewRecordableAdditions.m
//  Clue
//
//  Created by Ahmed Sulaiman on 3/16/17.
//  Copyright © 2017 Ahmed Sulaiman. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "UIImageView+CLUViewRecordableAdditions.h"

@interface CLUImageViewRecordableAdditions : XCTestCase
@property (nonatomic) UIImageView *testImageView;
@end

@implementation CLUImageViewRecordableAdditions

- (void)setUp {
    [super setUp];
    _testImageView = [UIImageView new];
    [_testImageView setFrame:CGRectMake(0, 0, 100, 100)];
    [_testImageView setBackgroundColor:[UIColor redColor]];
    [_testImageView setHidden:NO];
    [_testImageView setUserInteractionEnabled:YES];
    [_testImageView setTag:1];
}

- (void)tearDown {
    _testImageView = nil;
    [super tearDown];
}

- (void)testViewPropertyDictionary {
    // Initialize test variables
    NSArray<NSString *> *testAllPropertiesKeys = @[@"frame", @"backgroundColor",
                                                   @"hidden", @"userInteractionEnabled",
                                                   @"layoutMargins", @"tag", @"focused",
                                                   @"isAnimating", @"animationDuration",
                                                   @"animationRepeatCount", @"highlighted"];
    
    // Test Image View Property Dictionary
    NSDictionary *imageViewDictionary = [_testImageView clue_viewPropertiesDictionary];
    XCTAssertNotNil(imageViewDictionary, @"Image View Dictionary is invalid");
    XCTAssertEqual([imageViewDictionary count], 3, @"Image View Dictionary has wrong amount of items inside");
    
    // Test Image View Propeties sub Dictionary
    NSDictionary *propertiesDictionary = [imageViewDictionary objectForKey:@"properties"];
    XCTAssertNotNil(propertiesDictionary, @"Image View Dictionary has invalid properties sub dictionary");
    XCTAssertEqual([propertiesDictionary count], [testAllPropertiesKeys count], @"Image View properties sub dictionary has wrong amount of items inside");
    
    // Tests keysa and values in Image View Propeties sub Dictionary
    for (NSString *currentTestKey in testAllPropertiesKeys) {
        NSObject *objectForKey = [propertiesDictionary objectForKey:currentTestKey];
        XCTAssertNotNil(objectForKey, @"Object for key:%@ is invalid in Image View properties sub dictionary", currentTestKey);
    }
    
    // Tests Image View Subviews sub Dictionary
    NSDictionary *subviewsDictionary = [imageViewDictionary objectForKey:@"subviews"];
    XCTAssertNotNil(subviewsDictionary, @"Image View Dictionary has invalid subviews sub dictionary");
    XCTAssertEqual([subviewsDictionary count], 0, @"Image View properties sub dictionary has wrong amount of items inside");
    
    // Tests Image View class name
    NSString *className = [imageViewDictionary objectForKey:@"class"];
    XCTAssertNotNil(className, @"Label Dictionary has invalid class value");
    XCTAssertTrue([className isEqualToString:@"UIImageView"], @"Label Dictionary has wrong class name");
}



@end
