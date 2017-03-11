//
//  CLUVideoWriter.m
//  Clue
//
//  Created by Ahmed Sulaiman on 5/18/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import "CLUVideoWriter.h"

@interface CLUVideoWriter()

@property (nonatomic, strong) AVAssetWriter *videoWriter;
@property (nonatomic, strong) AVAssetWriterInput *videoWriterInput;
@property (nonatomic, strong) AVAssetWriterInputPixelBufferAdaptor *videoWriterAdaptor;
@property (nonatomic)         CVPixelBufferPoolRef outputBufferPool;

@end

@implementation CLUVideoWriter {
    CGColorSpaceRef _colorSpace;
}

- (instancetype)initWithOutputURL:(NSURL *)outputURL viewSize:(CGSize)size scale:(CGFloat)scale {
    self = [super init];
    if (self) {
        _outputURL = outputURL;
        _viewSize = size;
        _scale = scale;
        _colorSpace = CGColorSpaceCreateDeviceRGB();
        
        [self setupOutputPixelBufferPoolForViewSize:size scale:scale];
        [self setupAssetVideoWriterForURL:outputURL];
        [self setupAssetVideoWriterInputForViewSize:size scale:scale];
        [self setupVideoWriterAdoptor];
        
        [_videoWriter addInput:_videoWriterInput];
    }
    return self;
}

- (void)startWriting {
    [_videoWriter startWriting];
    [_videoWriter startSessionAtSourceTime:kCMTimeZero];
}

- (void)finishWriting {
    [self finishWritingWithHandler:nil];
}

- (void)finishWritingWithHandler:(void (^)(void))completionHandler {
    [_videoWriterInput markAsFinished];
    [_videoWriter finishWritingWithCompletionHandler:^{
        _videoWriterAdaptor = nil;
        _videoWriterInput = nil;
        _videoWriter = nil;
        CGColorSpaceRelease(_colorSpace);
        CVPixelBufferPoolRelease(_outputBufferPool);
        if (completionHandler) {
            completionHandler();
        }
    }];
}

- (BOOL)isReadyForWriting {
    return [_videoWriterInput isReadyForMoreMediaData];
}

- (BOOL)appendPixelBuffer:(CVPixelBufferRef)pixelBuffer forTimestamp:(CMTime)timestamp {
    return [_videoWriterAdaptor appendPixelBuffer:pixelBuffer withPresentationTime:timestamp];
}

- (AVAssetWriterStatus)status {
    return _videoWriter.status;
}

- (void)setupOutputPixelBufferPoolForViewSize:(CGSize)viewSize scale:(CGFloat)scale {
    _outputBufferPool = NULL;
    NSDictionary *bufferAttributes = @{(id)kCVPixelBufferPixelFormatTypeKey : @(kCVPixelFormatType_32BGRA),
                                       (id)kCVPixelBufferCGBitmapContextCompatibilityKey : @YES,
                                       (id)kCVPixelBufferWidthKey : @(viewSize.width * scale),
                                       (id)kCVPixelBufferHeightKey : @(viewSize.height * scale),
                                       (id)kCVPixelBufferBytesPerRowAlignmentKey : @(viewSize.width * scale * 4)};
    CVPixelBufferPoolCreate(NULL, NULL, (__bridge CFDictionaryRef)(bufferAttributes), &_outputBufferPool);
}

- (void)setupAssetVideoWriterForURL:(NSURL *)outputURL {
    NSError *error;
    _videoWriter = [[AVAssetWriter alloc] initWithURL:outputURL
                                             fileType:AVFileTypeQuickTimeMovie
                                                error:&error];
    NSParameterAssert(_videoWriter);
}

- (void)setupAssetVideoWriterInputForViewSize:(CGSize)viewSize scale:(CGFloat)scale {
    NSInteger pixelNumber = viewSize.width * viewSize.height * scale;
    NSDictionary *videoCompression = @{AVVideoAverageBitRateKey: @(pixelNumber * 11.4)};
    NSDictionary *videoSettings = @{AVVideoCodecKey: AVVideoCodecH264,
                                    AVVideoWidthKey: [NSNumber numberWithInt:viewSize.width * scale],
                                    AVVideoHeightKey: [NSNumber numberWithInt:viewSize.height * scale],
                                    AVVideoCompressionPropertiesKey: videoCompression};
    _videoWriterInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:videoSettings];
    NSParameterAssert(_videoWriterInput);
    _videoWriterInput.expectsMediaDataInRealTime = YES;
}

- (void)setupVideoWriterAdoptor {
    _videoWriterAdaptor = [AVAssetWriterInputPixelBufferAdaptor
                           assetWriterInputPixelBufferAdaptorWithAssetWriterInput:_videoWriterInput
                                                      sourcePixelBufferAttributes:nil];
    NSParameterAssert(_videoWriterAdaptor);
}

- (CGContextRef)bitmapContextForPixelBuffer:(CVPixelBufferRef *)pixelBuffer {
    CVPixelBufferPoolCreatePixelBuffer(NULL, _outputBufferPool, pixelBuffer);
    CVPixelBufferLockBaseAddress(*pixelBuffer, 0);
    
    CGContextRef bitmapContext = NULL;
    bitmapContext = CGBitmapContextCreate(CVPixelBufferGetBaseAddress(*pixelBuffer),
                                          CVPixelBufferGetWidth(*pixelBuffer),
                                          CVPixelBufferGetHeight(*pixelBuffer),
                                          8, CVPixelBufferGetBytesPerRow(*pixelBuffer),
                                          _colorSpace,
                                          kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    
    CGContextScaleCTM(bitmapContext, _scale, _scale);
    CGAffineTransform flipVertical = CGAffineTransformMake(1, 0, 0, -1, 0, _viewSize.height);
    CGContextConcatCTM(bitmapContext, flipVertical);
    
    return bitmapContext;
}


@end
