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

@end

@implementation CLUDataWriterTests

- (void)testAddDataWithIncorrectInput {
    // Initialize test variables
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *testOutputURL = [NSURL fileURLWithPath:@"test-file"];
    
    // Initialize Data Writer
    CLUDataWriter *dataWriter = [[CLUDataWriter alloc] initWithOutputURL:testOutputURL];
    
    // Start Writing and add nil data
    [dataWriter startWriting];
    [dataWriter addData:nil];
    [dataWriter finishWriting];
    
    // Test is output file exists
    BOOL isOutputFileExists = [fileManager fileExistsAtPath:testOutputURL.path];
    XCTAssertTrue(isOutputFileExists, @"Test Output File doesn't exists");
    
    // Test  if outout file is empty
    NSData *outputFileData = [NSData dataWithContentsOfURL:testOutputURL];
    XCTAssertEqual(outputFileData.length, 0, @"Contents length from Test Output File is incorrect");
    
    // Remove Test Output File
    NSError *error;
    [fileManager removeItemAtURL:testOutputURL error:&error];
    XCTAssertNil(error, @"Unexpected error while removing Test Output File");
}

- (void)testAddDataWithCorrectInput {
    // Initialize/Declare test variables
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *testContent = @"Test Data String Content";
    NSURL *testOutputURL = [NSURL fileURLWithPath:@"test-file"];
    NSData *testInputData = [testContent dataUsingEncoding:NSUTF8StringEncoding];
    NSData *testOutputData = [[testContent stringByAppendingString:@"\n"] dataUsingEncoding:NSUTF8StringEncoding];
    
    // Initialize Data Writer
    CLUDataWriter *dataWriter = [[CLUDataWriter alloc] initWithOutputURL:testOutputURL];
    
    // Start writinf process and add valid data
    [dataWriter startWriting];
    [dataWriter addData:testInputData];
    [dataWriter finishWriting];
    
    // Test if output file exists
    BOOL isOutputFileExists = [fileManager fileExistsAtPath:testOutputURL.path];
    XCTAssertTrue(isOutputFileExists, @"Test Output File doesn't exists");
    
    // Test if length in output file is equal to test output data
    NSData *outputFileData = [NSData dataWithContentsOfURL:testOutputURL];
    XCTAssertEqual(outputFileData.length, testOutputData.length, @"Contents length from Test Output File is incorrect");
    
    // Test if content of output file is equal to test output data
    NSString *outputFileString = [[NSString alloc] initWithData:outputFileData encoding:NSUTF8StringEncoding];
    NSString *testOutputFileString = [[NSString alloc] initWithData:testOutputData encoding:NSUTF8StringEncoding];
    XCTAssertTrue([outputFileString isEqualToString:testOutputFileString], @"Content from Test Output File is incorrect");
    
    // Remove test output file
    NSError *error;
    [fileManager removeItemAtURL:testOutputURL error:&error];
    XCTAssertNil(error, @"Unexpected error while removing Test Output File");
}

@end
