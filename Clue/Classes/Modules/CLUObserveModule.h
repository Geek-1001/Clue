//
//  CLUObserveModule.h
//  Clue
//
//  Created by Ahmed Sulaiman on 6/4/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLURecordableModule.h"

#define TIMESTAMP_KEY @"timestamp"

@interface CLUObserveModule : NSObject <CLURecordableModule>

@property (nonatomic, readonly) BOOL isRecording;
@property (nonatomic, readonly) CFTimeInterval currentTimeStamp;

- (BOOL)isBufferEmpty;
- (void)addData:(NSData *)bufferItem;
- (void)clearBuffer;

@end
