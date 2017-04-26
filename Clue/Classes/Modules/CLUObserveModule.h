//
//  CLUObserveModule.h
//  Clue
//
//  Created by Ahmed Sulaiman on 6/4/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLURecordableModule.h"

/**
 Default timestamp key name for `NSDictionary` with data which will be written to .json file
 */
#define TIMESTAMP_KEY @"timestamp"

/**
 `CLUObserveModule` is a base class for all modules which needs to observe their data (except `CLUVideoModule` module) and record them only if new data has arrived (like `CLUNetworkModule` or `CLUUserInteractionModule` modules) or something changed with next frame iteration (like `CLUViewStructureModule` module). This class is responsible for thread safety of new data writing via Writers and Data buffer management.
 */
@interface CLUObserveModule : NSObject <CLURecordableModule>

/**
 BOOL property which indicates whether video recording has started or not
 */
@property (nonatomic, readonly) BOOL isRecording;

/**
 Current available timestamp. This property updating constantly with `addNewFrameWithTimestamp:` from `CLURecordableModule` protocol
 */
@property (nonatomic, readonly) CFTimeInterval currentTimeStamp;

/**
 Indicate whether data buffer empty or not
 
 @return BOOL value which indicates whether data buffer empty or not
 */
- (BOOL)isBufferEmpty;

/**
 Add new `NSDictionary` object to buffer, so it could be saved to file via Writer on next iteration of `addNewFrameWithTimestamp:` from `CLURecordableModule` protocol

 @param bufferItem `NSDictionary` object which you need to save to buffer
 */
- (void)addData:(NSDictionary *)bufferItem;

/**
 Remove all `NSDictionary` entities from data buffer
 */
- (void)clearBuffer;

@end
