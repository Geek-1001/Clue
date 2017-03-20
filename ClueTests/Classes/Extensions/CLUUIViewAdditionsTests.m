//
//  CLUUIViewAdditionsTests.m
//  Clue
//
//  Created by Ahmed Sulaiman on 3/12/17.
//  Copyright © 2017 Ahmed Sulaiman. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "UIView+CLUViewRecordableAdditions.h"

@interface CLUViewRecordableAdditions : XCTestCase

@property (nonatomic) UIView *testView;
@property (nonatomic) UIView *testSubview;

@end

@implementation CLUViewRecordableAdditions

- (void)setUp {
    [super setUp];
    _testView = [UIView new];
    [_testView setFrame:CGRectMake(0, 0, 100, 100)];
    [_testView setBackgroundColor:[UIColor redColor]];
    [_testView setLayoutMargins:UIEdgeInsetsMake(10, 15, 20, 25)];
    [_testView setHidden:NO];
    [_testView setUserInteractionEnabled:YES];
    [_testView setTag:1];
    
    _testSubview = [UIView new];
    [_testSubview setFrame:CGRectMake(0, 0, 50, 50)];
    [_testSubview setBackgroundColor:[UIColor redColor]];
    [_testView addSubview:_testSubview];
}

- (void)tearDown {
    [_testSubview removeFromSuperview];
    _testSubview = nil;
    _testView = nil;
    [super tearDown];
}

- (void)testViewColorPropertyDictionary {
    // Initialize test variables
    UIColor *testColor = [UIColor redColor];
    CGFloat testRedComponent, testGreenComponent, testBlueComponent, testAlphaComponent;
    [testColor getRed:&testRedComponent
                green:&testGreenComponent
                 blue:&testBlueComponent
                alpha:&testAlphaComponent];
    NSDictionary *testColorDictionary = @{@"red" : @(testRedComponent),
                                          @"green" : @(testGreenComponent),
                                          @"blue" : @(testBlueComponent),
                                          @"alpha" : @(testAlphaComponent)};
    
    // Test Color Property Dictionary
    NSDictionary *colorDictionary = [_testView clue_colorPropertyDictionaryForColor:testColor];
    XCTAssertNotNil(colorDictionary, @"Color Property Dictionary is invalid");
    XCTAssertTrue([colorDictionary isEqualToDictionary:testColorDictionary], @"Color dictionary is not equal to test data");
}

- (void)testViewSizePropertyDictionary {
    // Initialize test variables
    CGSize testSize = CGSizeMake(100, 200);
    NSDictionary *testSizeDictionary = @{@"width" : @(100),
                                         @"height" : @(200)};
    
    // Test Size Property Dictionary
    NSDictionary *sizeDictionary = [_testView clue_sizePropertyDictionaryForSize:testSize];
    XCTAssertNotNil(sizeDictionary, @"Size Property Dictionary is invalid");
    XCTAssertTrue([sizeDictionary isEqualToDictionary:testSizeDictionary], @"Size Dictionary is not equal to test data");
}

- (void)testViewFontPropertyDictionary {
    // Initialize test variables
    // TODO: mock font to make it system independent. To check actual content of the dictionary
    UIFont *testFont = [UIFont systemFontOfSize:13];
    NSArray<NSString *> *testAllKeys = @[@"familyName", @"fontName",
                                         @"pointSize", @"lineHeight"];
    
    // Test Font Property Dictionary
    NSDictionary *fontDictionary = [_testView clue_fontPropertyDictionaryForFont:testFont];
    XCTAssertNotNil(fontDictionary, @"Font Property Dictionary is invalid");
    XCTAssertEqual([fontDictionary count], [testAllKeys count], @"Wrong amount of items in Font Proprty Dictionary");
    
    // Test Keys and Values in Font Property Dictionary
    for (int itemIndex = 0; itemIndex < [fontDictionary count]; itemIndex++) {
        NSString *currentTestKey = testAllKeys[itemIndex];
        
        if ([currentTestKey isEqualToString:@"familyName"]) {
            NSString *testFontFamilyName = testFont.familyName;
            NSString *fontFamilyName = [fontDictionary objectForKey:currentTestKey];
            XCTAssertNotNil(fontFamilyName, @"Font Family Name is invalid in Font Property Dictionary");
            XCTAssertTrue([fontFamilyName isEqualToString:testFontFamilyName], @"Font Family Name is incorrect in Font Property Dictionary");
            
        } else if ([currentTestKey isEqualToString:@"fontName"]) {
            NSString *testFontName = testFont.fontName;
            NSString *fontName = [fontDictionary objectForKey:currentTestKey];
            XCTAssertNotNil(fontName, @"Font Name is invalid in Font Property Dictionary");
            XCTAssertTrue([fontName isEqualToString:testFontName], @"Font Name is incorrect in Font Property Dictionary");
            
        } else if ([currentTestKey isEqualToString:@"pointSize"]) {
            NSNumber *testPointSize = @(testFont.pointSize);
            NSNumber *pointSize = [fontDictionary objectForKey:currentTestKey];
            XCTAssertNotNil(pointSize, @"Point Size is invalid in Font Proprty Dictionary");
            XCTAssertEqual(pointSize.floatValue, testPointSize.floatValue, @"Font point size is incorrect in Font Property Dictionary");
            
        } else if ([currentTestKey isEqualToString:@"lineHeight"]) {
            NSNumber *testLineHeight = @(testFont.lineHeight);
            NSNumber *lineHeight = [fontDictionary objectForKey:currentTestKey];
            XCTAssertNotNil(lineHeight, @"Line Height is invalid in Font Proprty Dictionary");
            XCTAssertEqual(lineHeight.floatValue, testLineHeight.floatValue, @"Font line height is incorrect in Font Property Dictionary");
        }
    }
}

- (void)testViewAttributedTextPropertyDictionary {
    // Initialize test variables
    NSAttributedString *testAttributedString = [[NSAttributedString alloc] initWithString:@"Test Attributed String"];
    NSDictionary *testAttributedStringDictionary = @{@"string" : @"Test Attributed String"};
    
    // Test Attributed String Property Dictionary
    NSDictionary *attributedStringDictionary = [_testView
                                                clue_attributedTextPropertyDictionaryForAttributedString:testAttributedString];
    XCTAssertNotNil(attributedStringDictionary, @"Attributed String Property Dictionary is invalid");
    XCTAssertTrue([attributedStringDictionary isEqualToDictionary:testAttributedStringDictionary], @"Attributes String is not equal to test data");
}

- (void)testViewPropertiesDictionary {
    // Initialize test variables
    // TODO: test actual values not only presence of this value in final dictionary
    NSArray<NSString *> *testAllPropertiesKeys = @[@"frame", @"backgroundColor",
                                                   @"hidden", @"userInteractionEnabled",
                                                   @"layoutMargins", @"tag", @"focused"];
    
    // Test View Property Dictionary
    NSDictionary *viewPropertyDictionary = [_testView clue_viewPropertiesDictionary];
    XCTAssertNotNil(viewPropertyDictionary, @"View Property Dictionary is invalid");
    XCTAssertEqual([viewPropertyDictionary count], 3,
                   @"View Property Dictionary have wrong amount of items inside, should be 2 (class, properties and subviews)");
    
    NSDictionary *propertiesDictionary = [viewPropertyDictionary objectForKey:@"properties"];
    XCTAssertNotNil(propertiesDictionary, @"View Property Dictionary don't have Properties subdictionary");
    XCTAssertEqual([propertiesDictionary count], [testAllPropertiesKeys count], @"View Properties sub dictionary has wrong amount of items inside");
    
    // Test Properties sub dictionary
    for (NSString *currentTestKey in testAllPropertiesKeys) {
        NSObject *currentObjectForKey = [propertiesDictionary objectForKey:currentTestKey];
        XCTAssertNotNil(currentObjectForKey, @"Object for key:%@ is invalid in Properties sub dictionary", currentTestKey);
    }
    
    // Test Subviews sub dictionary
    NSDictionary *subviewsDictionary = [viewPropertyDictionary objectForKey:@"subviews"];
    XCTAssertNotNil(subviewsDictionary, @"Subviews sub dictionary is invalid");
    XCTAssertEqual([subviewsDictionary count], 1, @"Subviews sub dictionary has wrong amount of items/subviews");
    
    // Test class name
    NSString *className = [viewPropertyDictionary objectForKey:@"class"];
    XCTAssertNotNil(className, @"Class name is invalid in View Properties Dictionary");
    XCTAssertTrue([className isEqualToString:@"UIView"], @"Class name on the view is incorrect");
}

- (void)testLayoutMarginPropertyDictionary {
    // Initialize test variables
    NSDictionary *testLayoutMarginDictionary = @{@"top" : @(10),
                                                 @"left" : @(15),
                                                 @"right" : @(25),
                                                 @"bottom" : @(20)};
    
    // Test Layout Margin Property Dictionary
    NSDictionary *layoutMarginDictionary = [_testView clue_layoutMarginsPropertyDictionary];
    XCTAssertNotNil(layoutMarginDictionary, @"Layout Margin Property Dictionary is invalid");
    XCTAssertTrue([layoutMarginDictionary isEqualToDictionary:testLayoutMarginDictionary],
                  @"Layout Margin Dictionary is not equal to test data");
}

- (void)testFramePropertyDictionary {
    // Initialize test variables
    NSDictionary *testFrameDictionary = @{@"x" : @(0),
                                          @"y" : @(0),
                                          @"width" : @(100),
                                          @"height" : @(100)};
    
    // Test Frame Property Dictionary
    NSDictionary *frameDictionary = [_testView clue_frameProprtyDictionary];
    XCTAssertNotNil(frameDictionary, @"Frame Property Dictionary is invalid");
    XCTAssertTrue([frameDictionary isEqualToDictionary:testFrameDictionary], @"Frame Dictionary is not equal to test data");
}

@end
