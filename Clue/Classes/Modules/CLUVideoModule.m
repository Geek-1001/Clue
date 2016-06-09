//
//  CLUVideoModule.m
//  Clue
//
//  Created by Ahmed Sulaiman on 5/18/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import "CLUVideoModule.h"

@interface CLUVideoModule()

@property (nonatomic) CLUVideoWriter *writer;

@end

@implementation CLUVideoModule {
    dispatch_queue_t _renderQueue;
    dispatch_queue_t _appendPixelBufferQueue;
    dispatch_semaphore_t _frameRenderingSemaphore;
    dispatch_semaphore_t _pixelAppendSemaphore;
}


- (instancetype)initWithWriter:(CLUVideoWriter *)writer {
    self = [super init];
    if (self) {
        _isRecording = NO;
        _writer = writer;
        
        _appendPixelBufferQueue = dispatch_queue_create("CLUVideoModule.append_pixel_buffer_queue", DISPATCH_QUEUE_SERIAL);
        _renderQueue = dispatch_queue_create("CLURecorder.render_queue", DISPATCH_QUEUE_SERIAL);
        dispatch_set_target_queue(_renderQueue, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0));
        
        _frameRenderingSemaphore = dispatch_semaphore_create(1);
        _pixelAppendSemaphore = dispatch_semaphore_create(1);
    }
    return self;
}

- (void)startRecording {
    if (!_isRecording) {
        [_writer startWriting];
        _isRecording = (_writer.status == AVAssetWriterStatusWriting);
    }
}

- (void)stopRecording {
    if (_isRecording) {
        _isRecording = NO;
        [_writer finishWriting];
    }
}

- (void)addNewFrameWithTimestamp:(CFTimeInterval)timestamp {
    // throttle the number of frames to prevent meltdown
    // technique gleaned from Brad Larson's answer here: http://stackoverflow.com/a/5956119
    if (dispatch_semaphore_wait(_frameRenderingSemaphore, DISPATCH_TIME_NOW) != 0) {
        return;
    }
    
    dispatch_async(_renderQueue, ^{
        if (![_writer isReadyForWriting]) {
            return;
        }
        CMTime presentTime = CMTimeMakeWithSeconds(timestamp, 1000);
        
        CVPixelBufferRef pixelBuffer = NULL;
        CGContextRef bitmapContext = [_writer bitmapContextForPixelBuffer:&pixelBuffer];
        
        dispatch_sync(dispatch_get_main_queue(), ^(){
            UIGraphicsPushContext(bitmapContext);
            for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
                [window drawViewHierarchyInRect:CGRectMake(0, 0, _writer.viewSize.width, _writer.viewSize.height)
                             afterScreenUpdates:NO];
            }
            UIGraphicsPopContext();
        });
        
        if (dispatch_semaphore_wait(_pixelAppendSemaphore, DISPATCH_TIME_NOW)) {
            dispatch_async(_appendPixelBufferQueue, ^{
                BOOL status = [_writer appendPixelBuffer:pixelBuffer forTimestamp:presentTime];
                if (!status) {
                    // TODO: inform WARNING unable to append pixelBuffer
                }
                
                CGContextRelease(bitmapContext);
                CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
                CVPixelBufferRelease(pixelBuffer);
                
                dispatch_semaphore_signal(_pixelAppendSemaphore);
            });
        } else {
            CGContextRelease(bitmapContext);
            CVPixelBufferUnlockBaseAddress(pixelBuffer, 0);
            CVPixelBufferRelease(pixelBuffer);
        }
        
        dispatch_semaphore_signal(_frameRenderingSemaphore);
    });
}

@end
