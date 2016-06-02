//
//  CLUViewStructureModule.m
//  Clue
//
//  Created by Ahmed Sulaiman on 5/26/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import "CLUViewStructureModule.h"
#import "UIView+CLUViewRecordableAdditions.h"
#import <UIKit/UIKit.h>
#import "CLUViewStructureWriter.h"

@interface CLUViewStructureModule()

@property (nonatomic) CLUViewStructureWriter *viewStructureWriter;
@property (nonatomic) CFTimeInterval firstTimestemp;
@property (nonatomic) NSDictionary *lastRecordedViewStructure;

@end

@implementation CLUViewStructureModule {
    dispatch_queue_t _recordQueue;
    dispatch_semaphore_t _frameRecordingSemaphore;
}

- (instancetype)initWithWriter:(CLUViewStructureWriter *)writer {
    self = [super  init];
    if (!self) {
        return nil;
    }
    _viewStructureWriter = writer;
    _isRecording = NO;
    _recordQueue = dispatch_queue_create("CLUViewStructureModule.record_queue", DISPATCH_QUEUE_SERIAL);
    dispatch_set_target_queue(_recordQueue, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0));
    _frameRecordingSemaphore = dispatch_semaphore_create(1);
    
    return self;
}

- (void)startRecording {
    if (!_isRecording) {
        _isRecording = YES;
        [_viewStructureWriter startWriting];
    }
}

- (void)stopRecording {
    if (_isRecording) {
        _isRecording = NO;
        [_viewStructureWriter finishWriting];
    }
}

- (void)addNewFrameWithTimestamp:(CFTimeInterval)timestamp {
    if (dispatch_semaphore_wait(_frameRecordingSemaphore, DISPATCH_TIME_NOW) != 0) {
        return;
    }
    
    dispatch_async(_recordQueue, ^{
        if (![_viewStructureWriter isReadyForWriting]) {
            return;
        }
        
        if (!_firstTimestemp) {
            _firstTimestemp = timestamp;
        }
        CFTimeInterval elapsedTimeInterval = timestamp - _firstTimestemp;

        NSDictionary *currentViewStructure;
        for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
            UIViewController *rootViewController = window.rootViewController;
            if (rootViewController) {
                if ([rootViewController.view class] == [UIView class]) {
                    currentViewStructure = [rootViewController.view clue_viewPropertiesDictionary];
                }
            }
        }
        
        if (!_lastRecordedViewStructure || ![_lastRecordedViewStructure isEqualToDictionary:currentViewStructure]) {
            [_viewStructureWriter addViewStructureProperties:currentViewStructure withTimeInterval:elapsedTimeInterval];
            _lastRecordedViewStructure = currentViewStructure;
        }
        
        dispatch_semaphore_signal(_frameRecordingSemaphore);
    });    
}

@end
