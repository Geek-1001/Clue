//
//  CLUViewStructureWriter.m
//  Clue
//
//  Created by Ahmed Sulaiman on 5/31/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import "CLUViewStructureWriter.h"

@interface CLUViewStructureWriter()

@property (nonatomic) BOOL isWriting;
@property (nonatomic) NSOutputStream *outputStream;

@end

@implementation CLUViewStructureWriter

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

- (void)addViewStructureProperties:(NSDictionary *)propertiesDictionary withTimeInterval:(CFTimeInterval)timeInterval {
    if (!propertiesDictionary) {
        return;
    }
    
    NSMutableDictionary *rootViewDictionary = [[NSMutableDictionary alloc] init];
    [rootViewDictionary setValue:[NSNumber numberWithDouble:timeInterval] forKey:@"timeInterval"];
    [rootViewDictionary setValue:propertiesDictionary forKey:@"view"];
    
    NSError *error;
    NSData *viewPropertiesData = [NSJSONSerialization dataWithJSONObject:rootViewDictionary options:0 error:&error];
    NSUInteger length = [viewPropertiesData length];
    
    NSInteger writeStatus = [_outputStream write:[viewPropertiesData bytes] maxLength:length];
    if (writeStatus < 0) {
        [self handleStreamError];
        return;
    }
    
    NSString *nextLineString = @"\n";
    NSData *nextLineData = [nextLineString dataUsingEncoding:NSUTF8StringEncoding];
    writeStatus = [_outputStream write:[nextLineData bytes] maxLength:[nextLineData length]];
    // Remove this copy-paste error checking block
    if (writeStatus < 0) {
        [self handleStreamError];
        return;
    }
}

- (void)handleStreamError {
    NSError *streamError = [_outputStream streamError];
    NSLog(@"Stream error : %@", [streamError localizedDescription]);
}

@end
