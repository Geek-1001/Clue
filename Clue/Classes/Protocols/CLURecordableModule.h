//
//  CLURecordableModule.h
//  Clue
//
//  Created by Ahmed Sulaiman on 5/18/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLUWritable.h"

/**
 `CLURecordableModule` protocol describe recordable module (like Video, View Structure, Network modules etc) which needs to track or inspect some specific information over time (like view structure for example) and record this information with specific timestamp using Writers
 
 @warning Every recordable modules have to implement this protocol to be able to work normally inside the system 
 */
@protocol CLURecordableModule <NSObject>

@required

/**
 Initialize recordable module with specific writer which implements `CLUWritable` protocol. So module will be able to record/write required information.
 
 @param writer Writer object which implements `CLUWritable` protocol. Responsible for actual writing information to some specific file (it could be video file, text file and etc)
 @return New instance of recordable module
 */
- (instancetype)initWithWriter:(id <CLUWritable>)writer;

/**
 Start recording for current recordable module. Usually you can do all preparations here and start actual recording (which is specific for your recordable module).
 */
- (void)startRecording;

/**
 Stop recording for current recordable module. Usually you can do all cleanup here and stop actual recording (which is specific for your recordable module).
 */
- (void)stopRecording;

/**
 This method will be called by third-party (see `CLUReportComposer`) when new frame with new timestamp is available. So usually your module needs to handle all recording related operations here and setup specific timestamp for new data entity.

 @param timestamp `CFTimeInterval` timestamp of new frame. So module can add new data if available for this timestamp
 */
- (void)addNewFrameWithTimestamp:(CFTimeInterval)timestamp;

@end
