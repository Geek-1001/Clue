//
//  CLUUserInteractionModule.m
//  Clue
//
//  Created by Ahmed Sulaiman on 6/4/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import "CLUUserInteractionModule.h"
#import "CLUDataWriter.h"

@interface CLUUserInteractionModule()

@property (nonatomic) CFTimeInterval currentTimeStamp;
@property (nonatomic) CFTimeInterval firstTimestemp;

@end

@implementation CLUUserInteractionModule

- (instancetype)initWithWriter:(CLUDataWriter *)writer {
    self = [super initWithWriter:writer];
    if (!self) {
        return nil;
    }
    // TODO: init gesture recogniser and method to handle user interactions
    return self;
}

- (void)startRecording {
    if (!self.isRecording) {
        [super startRecording];
        // TODO: setup gesture recognizer for root view(s)
    }
}

- (void)stopRecording {
    if (self.isRecording) {
        [super isRecording];
        // TODO: remove observers from views
    }
}

- (void)addNewFrameWithTimestamp:(CFTimeInterval)timestamp {
    if (!_firstTimestemp) {
        _firstTimestemp = timestamp;
    }
    _currentTimeStamp = timestamp - _firstTimestemp;
    [super addNewFrameWithTimestamp:timestamp];
}

@end
