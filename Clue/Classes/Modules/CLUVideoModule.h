//
//  CLUVideoModule.h
//  Clue
//
//  Created by Ahmed Sulaiman on 5/18/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CLURecordableModule.h"
#import "CLUVideoWriter.h"

/**
 `CLUVideoModule` is a class (module) for screen recording which implements `CLURecordableModule` protocol. It's responsible for thread safety while video recording, operations with `CVPixelBufferRef` and current view hierarchy drawing (see `[UIView drawViewHierarchyInRect:afterScreenUpdates:]`) and frames overlapping while recording.
 */
@interface CLUVideoModule : NSObject <CLURecordableModule>

/**
 BOOL property which indicates whether video recording has started or not
 */
@property (nonatomic, readonly) BOOL isRecording;

@end
