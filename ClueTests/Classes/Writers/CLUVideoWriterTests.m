//
//  CLUVideoWriterTests.m
//  Clue
//
//  Created by Ahmed Sulaiman on 3/10/17.
//  Copyright © 2017 Ahmed Sulaiman. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CLUVideoWriter.h"
#import <UIKit/UIKit.h>

@interface CLUVideoWriter (Testing)
- (void)finishWritingWithHandler:(void (^)(void))completionHandler;
@end

@interface CLUVideoWriterTests : XCTestCase

@end

@implementation CLUVideoWriterTests

- (void)testAppendPixelBuffer {
    // Initialize test variables
    CGSize testSize = CGSizeMake(375, 667);
    CGFloat testScale = 2.0;
    NSURL *testOutputURL = [NSURL fileURLWithPath:@"test-video-file.mp4"];
    CMTime testFrameTime = CMTimeMakeWithSeconds(4, 1000);
    CVPixelBufferRef testPixelBuffer = NULL;
    UIView *testView = [[UIView alloc] init];
    [testView setFrame:CGRectMake(0, 0, testSize.width, testSize.height)];
    testView.backgroundColor = [UIColor redColor];
    XCTestExpectation *videoFinishExpectation = [self expectationWithDescription:@"Video writing finished"];
    
    // Initialize Video Writer with test variables
    CLUVideoWriter *videoWriter = [[CLUVideoWriter alloc] initWithOutputURL:testOutputURL
                                                                   viewSize:testSize
                                                                      scale:testScale];
    
    // Start Writing Process
    [videoWriter startWriting];
    // Video Writer should be ready for writing
    XCTAssertTrue([videoWriter isReadyForWriting], @"Video Writer is not ready for writing");
    
    // Create Configured Pixel Buffer for reference
    CGContextRef bitmapContext = [videoWriter bitmapContextForPixelBuffer:&testPixelBuffer];
    XCTAssertNotEqual(bitmapContext, NULL, @"Bitmap Context can't be NULL");

    // Make created Bitmap Context as a main context and draw test view on this context
    UIGraphicsPushContext(bitmapContext);
    [testView drawViewHierarchyInRect:CGRectMake(0, 0, testSize.width, testSize.height)
                   afterScreenUpdates:NO];
    UIGraphicsPopContext();
    
    // Append pixel buffer with data
    BOOL appendPixelBufferStatus = [videoWriter appendPixelBuffer:testPixelBuffer
                                                     forTimestamp:testFrameTime];
    XCTAssertTrue(appendPixelBufferStatus, @"Can't append Pixel Buffer");

    // Clear bitmap context and test pixel buffer
    CGContextRelease(bitmapContext);
    CVPixelBufferUnlockBaseAddress(testPixelBuffer, 0);
    CVPixelBufferRelease(testPixelBuffer);
    
    // Finish Writing Process (Testable Method, doesn't exist in public interface)
    [videoWriter finishWritingWithHandler:^{
        // Remove Test Video File
        NSError *error;
        [[NSFileManager defaultManager] removeItemAtURL:testOutputURL error:&error];
        XCTAssertNil(error, @"Unexpected error while removing Test Video File");
        // Full fill the video writing expectation to finish async test
        [videoFinishExpectation fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
        }
    }];
}

@end
