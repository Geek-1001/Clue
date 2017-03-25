//
//  CLUDataWriter.h
//  Clue
//
//  Created by Ahmed Sulaiman on 6/4/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLUWritable.h"

/**
 `CLUDataWriter` class which responsible for all writing and saving process for regular data stream into final .json file (inside .clue report file)
 Used with all Recordable Modules (like View Structure, Network and User Interactions) to add data while report recording is active
 */
@interface CLUDataWriter : NSObject <CLUWritable, NSStreamDelegate>

/**
 URL of the file where `CLUDataWriter` will save recorded data
 */
@property (nonatomic, readonly) NSURL *outputURL;

/**
 Create new instance of Data Writer with specific output URL

 @param outputURL URL of the file where `CLUDataWriter` will save recorded data
 @return New instance of Data Writer with configured properties
 */
- (instancetype)initWithOutputURL:(NSURL *)outputURL;

/**
 Add `NSData` with entity's properties json dictionary to file at `CLUDataWriter.outputURL` URL

 @param data `NSData` object with entity's properties json dictionary (Network entity dictionary, View Structure dictionary or User Interaction dictionary)
 */
- (void)addData:(NSData *)data;

@end
