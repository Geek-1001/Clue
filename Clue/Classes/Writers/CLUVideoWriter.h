//
//  CLUVideoWriter.h
//  Clue
//
//  Created by Ahmed Sulaiman on 5/18/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "CLUWritable.h"

@interface CLUVideoWriter : NSObject <CLUWritable>

@property (nonatomic, readonly) CGSize viewSize;
@property (nonatomic, readonly) CGFloat scale;
@property (nonatomic, readonly) NSURL *outputURL;

- (instancetype)initWithOutputURL:(NSURL *)outputURL viewSize:(CGSize)size scale:(CGFloat)scale;

- (BOOL)appendPixelBuffer:(CVPixelBufferRef)pixelBuffer forTimestamp:(CMTime)timestamp;
- (AVAssetWriterStatus)status;
- (CGContextRef)bitmapContextForPixelBuffer:(CVPixelBufferRef *)pixelBuffer;

@end
