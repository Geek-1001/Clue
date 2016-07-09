//
//  Clue.m
//  Clue
//
//  Created by Ahmed Sulaiman on 5/11/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import "ClueController.h"
#import "CLUReportComposer.h"

#import "CLUVideoWriter.h"
#import "CLUVideoModule.h"
#import "CLUViewStructureWriter.h"
#import "CLUViewStructureModule.h"
#import "CLUUserInteractionModule.h"
#import "CLUNetworkModule.h"
#import "CLUDataWriter.h"
#import "NSException+CLUExceptionAdditions.h"
#import "CLUDeviceInfoModule.h"

@interface ClueController()

@property (nonatomic) BOOL isEnabled;
@property (nonatomic) BOOL isRecording;
@property (nonatomic) CLUOptions *options;
@property (nonatomic) CLUReportComposer *reportComposer;

@end

@implementation ClueController

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    _isEnabled = NO;
    _options = [[CLUOptions alloc] init];
    
    NSMutableArray *modulesArray = [self configureRecordableModules];
    NSMutableArray *infoModulesArray = [self configureInfoModules];
    _reportComposer = [[CLUReportComposer alloc] initWithModulesArray:modulesArray];
    [_reportComposer setInfoModules:infoModulesArray];
    NSSetUncaughtExceptionHandler(&didReceiveUncaughtException);
    
    return self;
}

+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static ClueController *instance;
    dispatch_once(&once, ^{
        instance = [[ClueController alloc] init];
    });
    return instance;
}

void didReceiveUncaughtException(NSException *exception) {
    [[ClueController sharedInstance] handleException:exception];
}

- (void)enable {
    if (!_isEnabled) {
        _isEnabled = YES;
        [self configureWithOptions:_options];
    }
}

- (void)handleException:(NSException *)exception {
    if (!exception || !_isEnabled || !_isRecording) {
        return;
    }
    NSURL *outputURL = [NSURL fileURLWithPath:@"/Users/Ahmed/Desktop/exception.json"]; // TODO: change harcoded file path
    CLUDataWriter *dataWriter = [[CLUDataWriter alloc] initWithOutputURL:outputURL];
    NSDictionary *exceptionProperties = [exception clue_exceptionProperties];
    dispatch_queue_t stopRecodingQueue = dispatch_queue_create("ClueController.stopRecodingQueue", DISPATCH_QUEUE_SERIAL);
    
    if ([NSJSONSerialization isValidJSONObject:exceptionProperties]) {
        NSError *error;
        NSData *exceptionData = [NSJSONSerialization dataWithJSONObject:exceptionProperties options:0 error:&error];
        if (!error && exceptionData) {
            [dataWriter startWriting];
            [dataWriter addData:exceptionData];
            [dataWriter finishWriting];
        }
    } else {
        NSLog(@"Exception properties json is invalid");
    }
    
    dispatch_sync(stopRecodingQueue, ^{
        [self stopRecording];
        // Crazy hack! If exception occurs wait till video writer finish async handler -[AVAssetWriter finishWritingWithCompletionHandler]
        // TODO: come up with better approach
        [NSThread sleepForTimeInterval:3];
    });    
}

- (void)handleShake:(UIEventSubtype)motion {
    if (motion !=  UIEventSubtypeMotionShake || !_isEnabled) {
        // TODO: print warning message
        return;
    }
    if (_isRecording) {
        [self stopRecording];
    } else {
        [self startRecording];
    }
}

- (void)startRecording {
    if (!_isRecording) {
        _isRecording = YES;
        [_reportComposer startRecording];
    }
}

- (void)stopRecording {
    if (_isRecording) {
        _isRecording = NO;
        [_reportComposer stopRecording];
    }
}

- (void)disable {
    if (_isEnabled) {
        _isEnabled = NO;
        // TODO: clear everything redundant
    }
}

- (void)enableWithOptions:(CLUOptions *)options {
    [self configureWithOptions:options];
    _isEnabled = YES;
}

- (void)configureWithOptions:(nullable CLUOptions *)options {
    if (!options) {
        options = [[CLUOptions alloc] init];
    }
    _options = options;
    // TODO: additional configuration
}

- (NSMutableArray *)configureRecordableModules {
    NSMutableArray *modulesArray = [[NSMutableArray alloc] init];
    
    CLUVideoModule *videoModul = [self configureVideoModule];
    CLUViewStructureModule *viewStructureModule = [self configureViewStructureModule];
    CLUUserInteractionModule *userInteractionModule = [self configureUserInteractionModule];
    CLUNetworkModule *networkModule = [self configureNetworkModule];
    
    [modulesArray addObject:videoModul];
    [modulesArray addObject:viewStructureModule];
    [modulesArray addObject:userInteractionModule];
    [modulesArray addObject:networkModule];
    
    return modulesArray;
}

- (NSMutableArray *)configureInfoModules {
    NSMutableArray *modulesArray = [[NSMutableArray alloc] init];
    CLUDeviceInfoModule *deviceModule = [self configureDeviceInfoModule];
    [modulesArray addObject:deviceModule];
    return modulesArray;
}

#pragma mark - Configure Recoradble modules

- (CLUVideoModule *)configureVideoModule {
    CGSize viewSize = [UIApplication sharedApplication].delegate.window.bounds.size;
    CGFloat scale = [UIScreen mainScreen].scale;
    NSURL *outputURL = [NSURL fileURLWithPath:@"/Users/Ahmed/Desktop/screencast.mp4"]; // TODO: change harcoded file path
    CLUVideoWriter *videoWriter = [[CLUVideoWriter alloc] initWithOutputURL:outputURL viewSize:viewSize scale:scale];
    CLUVideoModule *videoModule = [[CLUVideoModule alloc] initWithWriter:videoWriter];
    return videoModule;
}

- (CLUViewStructureModule *)configureViewStructureModule {
    NSURL *outputURL = [NSURL fileURLWithPath:@"/Users/Ahmed/Desktop/screencast.json"]; // TODO: change harcoded file path
    CLUViewStructureWriter *viewStructureWriter = [[CLUViewStructureWriter alloc] initWithOutputURL:outputURL];
    CLUViewStructureModule *viewStructureModule = [[CLUViewStructureModule alloc] initWithWriter:viewStructureWriter];
    return viewStructureModule;
}

- (CLUUserInteractionModule *)configureUserInteractionModule {
    NSURL *outputURL = [NSURL fileURLWithPath:@"/Users/Ahmed/Desktop/user_interaction.json"]; // TODO: change harcoded file path
    CLUDataWriter *dataWriter = [[CLUDataWriter alloc] initWithOutputURL:outputURL];
    CLUUserInteractionModule *userInteractionModule = [[CLUUserInteractionModule alloc] initWithWriter:dataWriter];
    return userInteractionModule;
}

- (CLUNetworkModule *)configureNetworkModule {
    NSURL *outputURL = [NSURL fileURLWithPath:@"/Users/Ahmed/Desktop/network_operations.json"]; // TODO: change harcoded file path
    CLUDataWriter *dataWriter = [[CLUDataWriter alloc] initWithOutputURL:outputURL];
    CLUNetworkModule *networkModule = [[CLUNetworkModule alloc] initWithWriter:dataWriter];
    return networkModule;
}

#pragma mark - Configure Info modules

- (CLUDeviceInfoModule *)configureDeviceInfoModule {
    NSURL *outputURL = [NSURL fileURLWithPath:@"/Users/Ahmed/Desktop/device.json"]; // TODO: change harcoded file path
    CLUDataWriter *dataWriter = [[CLUDataWriter alloc] initWithOutputURL:outputURL];
    CLUDeviceInfoModule *deviceModule = [[CLUDeviceInfoModule alloc] initWithWriter:dataWriter];
    return deviceModule;
}

@end
