//
//  CLUDataWriter.m
//  Clue
//
//  Created by Ahmed Sulaiman on 6/4/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import "CLUDataWriter.h"

@interface CLUDataWriter()

@property (nonatomic) BOOL isWriting;
@property (nonatomic) NSOutputStream *outputStream;

@end

@implementation CLUDataWriter

- (instancetype)initWithOutputURL:(NSURL *)outputURL {
    self = [super init];
    if (!self) {
        return nil;
    }
    _isWriting = NO;
    _outputURL = outputURL;
    _outputStream = [NSOutputStream outputStreamWithURL:outputURL append:YES];
    [_outputStream setDelegate:self];
    [_outputStream scheduleInRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    return self;
}

- (BOOL)isReadyForWriting {
    BOOL isReady = NO;
    NSStreamStatus streamStatus = [_outputStream streamStatus];
    if (streamStatus == NSStreamStatusOpen && _isWriting) {
        isReady = YES;
    }
    return isReady;
}

- (void)finishWriting {
    if (_isWriting) {
        _isWriting = NO;
        
        [_outputStream close];
        [_outputStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        _outputStream = nil;
    }
}

- (void)startWriting {
    if (!_isWriting) {
        _isWriting = YES;
        [_outputStream open];
    }
}

- (void)stream:(NSStream *)stream handleEvent:(NSStreamEvent)eventCode {
    NSUInteger eventCodeInteger = (NSUInteger) eventCode;
    switch(eventCodeInteger) {
        case NSStreamEventErrorOccurred:
            [self handleStreamError];
            break;
    }
}

- (void)handleStreamError {
    NSError *streamError = [_outputStream streamError];
    NSLog(@"Stream error : %@", [streamError localizedDescription]);
}

- (void)addData:(NSData *)data {
    if (!data) {
        return;
    }
    
    NSInteger dataLength = [data length];
    const void *dataBytes = [data bytes];
    NSInteger writeStatus = [_outputStream write:dataBytes maxLength:dataLength];
    if (writeStatus < 0) {
        [self handleStreamError];
        return;
    }
    
    NSString *nextLineString = @"\n";
    NSData *nextLineData = [nextLineString dataUsingEncoding:NSUTF8StringEncoding];
    NSInteger nextLineDataLength = [nextLineData length];
    const void *nextLineDataBytes = [nextLineData bytes];
    
    writeStatus = [_outputStream write:nextLineDataBytes maxLength:nextLineDataLength];
    if (writeStatus < 0) {
        [self handleStreamError];
        return;
    }
}

@end
