//
//  CLUReportComposer.h
//  Clue
//
//  Created by Ahmed Sulaiman on 5/19/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLURecordableModule.h"

@interface CLUReportComposer : NSObject

@property (nonatomic, readonly) NSMutableArray *recordableModules;
@property (nonatomic, readonly) NSURL *outputURL;
@property (nonatomic, readonly) BOOL isRecording;

- (instancetype)initWithReportOutputURL:(NSURL *)outputURL;

- (void)addRecordableModule:(id <CLURecordableModule>)module;
- (void)removeRecordableModule:(id <CLURecordableModule>)module;

- (void)startRecording;
- (void)stopRecording;

@end
