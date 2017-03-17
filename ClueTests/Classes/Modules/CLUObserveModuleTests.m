//
//  CLUObserveModuleTests.m
//  Clue
//
//  Created by Ahmed Sulaiman on 3/17/17.
//  Copyright © 2017 Ahmed Sulaiman. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CLUObserveModule.h"
#import "CLUDataWriter.h"

@interface CLUObserveModuleTests : XCTestCase
@property (nonatomic) CLUObserveModule *observeModule;
@property (nonatomic) NSURL *testOutputURL;
@end

@implementation CLUObserveModuleTests

- (void)setUp {
    [super setUp];
    _testOutputURL = [NSURL fileURLWithPath:@"test-file"];
    CLUDataWriter *dataWriter = [[CLUDataWriter alloc] initWithOutputURL:_testOutputURL];
    _observeModule = [[CLUObserveModule alloc] initWithWriter:dataWriter];
}

- (void)tearDown {
    _observeModule = nil;
    NSError *error;
    [[NSFileManager defaultManager] removeItemAtURL:_testOutputURL error:&error];
    XCTAssertNil(error, @"Unexpected error while removing Test Output File");
    _testOutputURL = nil;
    [super tearDown];
}

- (void)testAddDataToBuffer {
    // Initialize test variables
    NSData *testData = [@"test-content" dataUsingEncoding:NSUTF8StringEncoding];
    
    // Start recording
    [_observeModule startRecording];
    XCTAssertTrue(_observeModule.isRecording, @"Observe Module isRecording property is incorrect after startRecording:");
    
    // Check Buffer for empty
    XCTAssertTrue([_observeModule isBufferEmpty], @"Observe Module Buffer is not empty after recoding");
    
    // Add data
    [_observeModule addData:testData];
    XCTAssertFalse([_observeModule isBufferEmpty], @"Observe Module Buffer is empty after addData: call");
    
    // Clear buffer
    [_observeModule clearBuffer];
    XCTAssertTrue([_observeModule isBufferEmpty], @"Observe Module Buffer is not empty after clearBuffer:");
    
    // Stop recording
    [_observeModule stopRecording];
    XCTAssertFalse(_observeModule.isRecording, @"Observe Module isRecording property is incorrect after stopRecording:");
}

@end
