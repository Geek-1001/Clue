//
//  CLUWritable.h
//  Clue
//
//  Created by Ahmed Sulaiman on 5/18/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 `CLUWritable` protocol describe writers (like `CLUVideoWriter`) which needs to actually write new data to specific file (could be text file, video file etc.)
 */
@protocol CLUWritable <NSObject>

@required

/**
 Get writer status, whether Writer is ready to write new data or not
 
 @return BOOL value which specify whether Writer is ready to write new data or not
 */
- (BOOL)isReadyForWriting;

/**
 Finish actual writing with all necessary cleanup
 */
- (void)finishWriting;

/**
 Start actual writing with all necessary preparations
 */
- (void)startWriting;

@end
