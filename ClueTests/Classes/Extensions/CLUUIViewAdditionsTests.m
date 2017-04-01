//
//  CLUUIViewAdditionsTests.m
//  Clue
//
//  Created by Ahmed Sulaiman on 3/12/17.
//  Copyright © 2017 Ahmed Sulaiman. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "UIView+CLUViewRecordableAdditions.h"
#import <OCHamcrestIOS/OCHamcrestIOS.h>
#import <OCMockitoIOS/OCMockitoIOS.h>

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
    // Initialize test variables (mock UIFont instance)
    UIFont *testFont = mock([UIFont class]);
    [given(testFont.familyName) willReturn:@"TestFontFamily"];
    [given(testFont.fontName) willReturn:@"TestFontName"];
    [given(testFont.pointSize) willReturn:@10];
    [given(testFont.lineHeight) willReturn:@13];

    NSDictionary *testFontDictionary = @{@"familyName" : @"TestFontFamily",
                                         @"fontName" : @"TestFontName",
                                         @"pointSize" : @10,
                                         @"lineHeight" : @13};
    
    // Test Font Property Dictionary
    NSDictionary *fontDictionary = [_testView clue_fontPropertyDictionaryForFont:testFont];
    XCTAssertNotNil(fontDictionary, @"Font Property Dictionary is invalid");
    XCTAssertTrue([fontDictionary isEqualToDictionary:testFontDictionary], @"Font Dictionary is not equal to test data");
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
    NSDictionary *testPropertiesDictionary = @{@"frame" : @{
                                                            @"x" : @0,
                                                            @"y" : @0,
                                                            @"width" : @100,
                                                            @"height" : @100
                                                           },
                                              @"backgroundColor" : @{
                                                                    @"red" : @1,
                                                                    @"green" : @0,
                                                                    @"blue" : @0,
                                                                    @"alpha" : @1
                                                                    },
                                               @"hidden" : @0,
                                               @"userInteractionEnabled" : @1,
                                               @"layoutMargins" : @{
                                                                    @"left" : @15,
                                                                    @"top" : @10,
                                                                    @"right" : @25,
                                                                    @"bottom" : @20
                                                                    },
                                               @"tag" : @1,
                                               @"focused" : @0};

    // Test View Property Dictionary
    NSDictionary *viewPropertyDictionary = [_testView clue_viewPropertiesDictionary];
    XCTAssertNotNil(viewPropertyDictionary, @"View Property Dictionary is invalid");
    XCTAssertEqual([viewPropertyDictionary count], 3,
                   @"View Property Dictionary have wrong amount of items inside, should be 2 (class, properties and subviews)");
    
    // Test properties sub dictionary and its content
    NSDictionary *propertiesDictionary = [viewPropertyDictionary objectForKey:@"properties"];
    XCTAssertNotNil(propertiesDictionary, @"View Property Dictionary don't have Properties subdictionary");
    XCTAssertTrue([propertiesDictionary isEqualToDictionary:testPropertiesDictionary], @"View Property Dictionary is not equal to test data");
    
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
