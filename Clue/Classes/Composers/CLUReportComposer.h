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
#import "CLUInfoModule.h"

/**
 `CLUReportComposer` is a class responsible for composing final Clue report from many pieces/modules. This class initialize all recordable and info modules and actually start recording. `CLUReportComposer` also calling `addNewFrameWithTimestamp:` method from `CLURecordableModule` protocol for every recordable module and `recordInfoData` method from `CLUInfoModule` protocol for every info module.
 */
@interface CLUReportComposer : NSObject

/**
 All info modules which will record their data only once during recording
 */
@property (nonatomic, readonly) NSMutableArray<id <CLUInfoModule>> *infoModules;

/**
 All recordable modules which will record their data during recording with specific timestamp for each new data entity
 */
@property (nonatomic, readonly) NSMutableArray<id <CLURecordableModule>> *recordableModules;

/**
 BOOL property which is indicate whether record has started or not
 */
@property (nonatomic, readonly) BOOL isRecording;

/**
 Initialize new `CLUReportComposer` instance with recordable modules array. So you can do recording even without info modules, but you have to have recordable modules for report recording

 @param modulesArray Recordable modules array which will record their data during recording with specific timestamp for each new data entity
 @return New `CLUReportComposer` instance
 */
- (instancetype)initWithModulesArray:(NSArray<id <CLURecordableModule>> *)modulesArray;

/**
 Add more recordable modules to `CLUReportComposer.recordableModules` array

 @param module Array with recordable modules which will be added to `CLUReportComposer.recordableModules`
 */
- (void)addRecordableModule:(id <CLURecordableModule>)module;

/**
 Remove single recordable module from `CLUReportComposer.recordableModules` array

 @param module Single recordable module which will be removed from `CLUReportComposer.recordableModules`
 */
- (void)removeRecordableModule:(id <CLURecordableModule>)module;

/**
 Set info modules array to be used once during recording. Needs to be setup before actual recording.

 @param infoModules Info modules array which will record their data only once during recording
 */
- (void)setInfoModules:(NSMutableArray<id<CLUInfoModule>> *)infoModules;

/**
 Start actual recording
 */
- (void)startRecording;

/**
 Stop actual recording
 */
- (void)stopRecording;

@end
