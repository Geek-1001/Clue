//
//  CLUReportComposer.m
//  Clue
//
//  Created by Ahmed Sulaiman on 5/19/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import "CLUReportComposer.h"

@interface CLUReportComposer()

@property (nonatomic) CADisplayLink *displayLink;

@end

@implementation CLUReportComposer {
    dispatch_queue_t _mainRecordQueue;
    dispatch_queue_t _moduleRecordQueue;
    dispatch_semaphore_t _recordSemaphore;
}

- (instancetype)init {
    self = [super init];
    // TODO: make same initializer in other classes
    if (!self) {
        return nil;
    }
    
    _isRecording = NO;
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(onScreenUpdate)];
    _recordableModules = [[NSMutableArray alloc] init];
    
    _moduleRecordQueue = dispatch_queue_create("CLUReportComposer.module_record_queue", DISPATCH_QUEUE_SERIAL);
    _mainRecordQueue = dispatch_queue_create("CLUReportComposer.main_record_queue", DISPATCH_QUEUE_SERIAL);
    dispatch_set_target_queue(_mainRecordQueue, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0));
    _recordSemaphore = dispatch_semaphore_create(1);
    
    return self;
}

- (void)addRecordableModule:(id <CLURecordableModule>)module {
    if (module && !_isRecording) {
        [_recordableModules addObject:module];
    }
}

- (void)removeRecordableModule:(id <CLURecordableModule>)module {
    if (module && !_isRecording) {
        [_recordableModules removeObject:module];
    }
}

- (void)startRecording {
    if (!_isRecording) {
        _isRecording = YES;
        for (id <CLURecordableModule> module in _recordableModules) {
            [module startRecording];
        }
        [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
}

- (void)stopRecording {
    if (_isRecording) {
        _isRecording = NO;
        for (id <CLURecordableModule> module in _recordableModules) {
            [module stopRecording];
        }
        [_displayLink removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
}

- (void)onScreenUpdate {
    if (dispatch_semaphore_wait(_recordSemaphore, DISPATCH_TIME_NOW) != 0) {
        return;
    }
    dispatch_async(_mainRecordQueue, ^{
        for (id <CLURecordableModule> module in _recordableModules) {
            dispatch_async(_moduleRecordQueue, ^{
                [module addNewFrameWithTimestamp:_displayLink.timestamp];
            });
        }
        dispatch_semaphore_signal(_recordSemaphore);
    });
}

@end
