//
//  CLUReportComposer.h
//  Clue
//
//  Created by Ahmed Sulaiman on 5/19/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CLURecordableModule.h"

@interface CLUReportComposer : NSObject

@property (nonatomic, readonly) NSMutableArray<id <CLURecordableModule>> *recordableModules;
@property (nonatomic, readonly) BOOL isRecording;

- (instancetype)initWithModulesArray:(NSArray<id <CLURecordableModule>> *)modulesArray;

- (void)addRecordableModule:(id <CLURecordableModule>)module;
- (void)removeRecordableModule:(id <CLURecordableModule>)module;

- (void)startRecording;
- (void)stopRecording;

@end
