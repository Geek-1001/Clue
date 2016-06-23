//
//  CLUObserveModule.m
//  Clue
//
//  Created by Ahmed Sulaiman on 6/4/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import "CLUObserveModule.h"
#import "CLUDataWriter.h"

@interface CLUObserveModule()

@property (atomic) NSMutableArray<NSData *> *bufferArray;
@property (nonatomic) CLUDataWriter *writer;

@end

@implementation CLUObserveModule {
    dispatch_queue_t _recordQueue;
    dispatch_semaphore_t _frameRecordingSemaphore;
}

- (instancetype)initWithWriter:(CLUDataWriter *)writer {
    self = [super init];
    if (!self) {
        return nil;
    }
    _writer = writer;
    _bufferArray = [[NSMutableArray alloc] init];
    _isRecording = NO;
    _currentTimeStamp = 0;
    _recordQueue = dispatch_queue_create("CLUObserveModule.record_queue", DISPATCH_QUEUE_SERIAL);
    dispatch_set_target_queue(_recordQueue, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0));
    _frameRecordingSemaphore = dispatch_semaphore_create(1);
    
    return self;
}

- (void)startRecording {
    if (!_isRecording) {
        _isRecording = YES;
        [_writer startWriting];
    }
}

- (void)stopRecording {
    if (_isRecording) {
        _isRecording = NO;
        [_writer finishWriting];
        
        [self clearBuffer];
        _bufferArray = nil;
    }
}

- (void)addNewFrameWithTimestamp:(CFTimeInterval)timestamp {
    _currentTimeStamp = timestamp;
    if (dispatch_semaphore_wait(_frameRecordingSemaphore, DISPATCH_TIME_NOW) != 0) {
        return;
    }
    
    dispatch_async(_recordQueue, ^{
        if (![self isBufferEmpty]) {
            
            if (![_writer isReadyForWriting]) {
                return;
            }
            
            for (NSData *data in _bufferArray) {
                [_writer addData:data];
            }
            
            [self clearBuffer];
        }
        dispatch_semaphore_signal(_frameRecordingSemaphore);
    });
}

- (BOOL)isBufferEmpty {
    return [_bufferArray count] == 0;
}

- (void)clearBuffer {
    @synchronized (self) {
        [_bufferArray removeAllObjects];
    }
}

- (void)addData:(NSData *)bufferItem {
    @synchronized (self) {
        if (bufferItem) {
            [_bufferArray addObject:bufferItem];
        }
    }
}

@end
