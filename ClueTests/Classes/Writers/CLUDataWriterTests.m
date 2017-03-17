//
//  CLUDataWriterTests.m
//  Clue
//
//  Created by Ahmed Sulaiman on 3/10/17.
//  Copyright © 2017 Ahmed Sulaiman. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CLUDataWriter.h"

@interface CLUDataWriterTests : XCTestCase

@property (nonatomic) NSString *testContent;
@property (nonatomic) NSFileManager *fileManager;
@property (nonatomic) NSURL *testOutputURL;
@property (nonatomic) CLUDataWriter *dataWriter;

@end

@implementation CLUDataWriterTests

- (void)setUp {
    [super setUp];
    // Initialize test variables
    _fileManager = [NSFileManager defaultManager];
    _testOutputURL = [NSURL fileURLWithPath:@"test-file"];
    _testContent = @"Test Data String Content";
    
    // Initialize Data Writer
    _dataWriter = [[CLUDataWriter alloc] initWithOutputURL:_testOutputURL];
}

- (void)tearDown {
    NSError *error;
    [_fileManager removeItemAtURL:_testOutputURL error:&error];
    XCTAssertNil(error, @"Unexpected error while removing Test Output File");
    _fileManager = nil;
    _dataWriter = nil;
    _testOutputURL = nil;
    [super tearDown];
}

- (void)testAddDataWithIncorrectInput {
    // Start Writing and add nil data
    [_dataWriter startWriting];
    [_dataWriter addData:nil];
    [_dataWriter finishWriting];
    
    // Test is output file exists
    BOOL isOutputFileExists = [_fileManager fileExistsAtPath:_testOutputURL.path];
    XCTAssertTrue(isOutputFileExists, @"Test Output File doesn't exists");
    
    // Test  if outout file is empty
    NSData *outputFileData = [NSData dataWithContentsOfURL:_testOutputURL];
    XCTAssertEqual(outputFileData.length, 0, @"Contents length from Test Output File is incorrect");
}

- (void)testAddDataWithCorrectInput {
    // Initialize/Declare test variables
    NSData *testInputData = [_testContent dataUsingEncoding:NSUTF8StringEncoding];
    NSData *testOutputData = [[_testContent stringByAppendingString:@"\n"] dataUsingEncoding:NSUTF8StringEncoding];
    
    // Start writinf process and add valid data
    [_dataWriter startWriting];
    [_dataWriter addData:testInputData];
    [_dataWriter finishWriting];
    
    // Test if output file exists
    BOOL isOutputFileExists = [_fileManager fileExistsAtPath:_testOutputURL.path];
    XCTAssertTrue(isOutputFileExists, @"Test Output File doesn't exists");
    
    // Test if length in output file is equal to test output data
    NSData *outputFileData = [NSData dataWithContentsOfURL:_testOutputURL];
    XCTAssertEqual(outputFileData.length, testOutputData.length, @"Contents length from Test Output File is incorrect");
    
    // Test if content of output file is equal to test output data
    NSString *outputFileString = [[NSString alloc] initWithData:outputFileData encoding:NSUTF8StringEncoding];
    NSString *testOutputFileString = [[NSString alloc] initWithData:testOutputData encoding:NSUTF8StringEncoding];
    XCTAssertTrue([outputFileString isEqualToString:testOutputFileString], @"Content from Test Output File is incorrect");
}

@end
