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

/**
 `CLUVideoWriter` class which responsible for all writing and saving process for video stream from device's screen. 
 Used with Video Module to record screen while report recording is active
 */
@interface CLUVideoWriter : NSObject <CLUWritable>

/**
 Size of final video. Depends on recorded view size
 */
@property (nonatomic, readonly) CGSize viewSize;

/**
 Current device's screen scale. To generate bitmap with correct size depending on scale
 */
@property (nonatomic, readonly) CGFloat scale;

/**
 URL of the final video file where Video Writer will save final recorded file
 */
@property (nonatomic, readonly) NSURL *outputURL;

/**
 Create new instance of Video Writer with scpecific output URL, view size and scale

 @param outputURL URL of the final video file where Video Writer will save final recorded file
 @param size Size of final video. Depends on recorded view size
 @param scale Current device's screen scale. To generate bitmap with correct size depending on scale
 @return New instance of Video Writer with configured properties
 */
- (instancetype)initWithOutputURL:(NSURL *)outputURL viewSize:(CGSize)size scale:(CGFloat)scale;

/**
 Append pixel buffer, current top view representation as a pixel buffer (See [UIView drawViewHierarchyInRect:afterScreenUpdates:] for drawing view Hierarchy on specific context) for specific timestamp

 @param pixelBuffer The `CVPixelBufferRef` to be appended.
 @param timestamp The presentation time for the pixel buffer to be appended.
 @return A BOOL value indicating success of appending the pixel buffer. If a result of NO is returned, clients can check the value of `[CLUVideoWriter status]` to determine whether the writing operation completed, failed, or was cancelled.
 
 @see -bitmapContextForPixelBuffer:
 */
- (BOOL)appendPixelBuffer:(CVPixelBufferRef)pixelBuffer forTimestamp:(CMTime)timestamp;

/**
 @return The status of writing samples to the receiver's output file.
 */
- (AVAssetWriterStatus)status;

/**
 Create `CGContextRef` Bitmap context with correct width, height, color space and bytes per row for specific pixel buffer

 @param pixelBuffer The empty `CVPixelBufferRef`
 @return `CGContextRef` Bitmap context on which client can draw view representation. (See [UIView drawViewHierarchyInRect:afterScreenUpdates:] to draw view on specific context)
 */
- (CGContextRef)bitmapContextForPixelBuffer:(CVPixelBufferRef *)pixelBuffer;

@end
