//
//  Clue.m
//  Clue
//
//  Created by Ahmed Sulaiman on 5/11/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import "ClueController.h"
#import "CLUReportComposer.h"

#import "CLUReportFileManager.h"
#import "CLUMailHelper.h"
#import "CLUMailDelegate.h"
#import "CLURecordIndicatorViewManager.h"

#import <Clue/Clue-Swift.h>

@interface ClueController()

@property (nonatomic) BOOL isEnabled;
@property (nonatomic) BOOL isRecording;
@property (nonatomic) CLUOptions *options;
@property (nonatomic) CLUReportComposer *reportComposer;
@property (nonatomic) CLUMailDelegate *mailDelegate;

@end

@implementation ClueController {
    dispatch_queue_t _waitVideoRenderingQueue;
}

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    _isEnabled = NO;
    NSMutableArray *modulesArray = [self configureRecordableModules];
    NSMutableArray *infoModulesArray = [self configureInfoModules];
    _reportComposer = [[CLUReportComposer alloc] initWithModulesArray:modulesArray];
    [_reportComposer setInfoModules:infoModulesArray];
    NSSetUncaughtExceptionHandler(&didReceiveUncaughtException);
    _waitVideoRenderingQueue = dispatch_queue_create("ClueController.waitVideoRenderingQueue", DISPATCH_QUEUE_SERIAL);
    _mailDelegate = [[CLUMailDelegate alloc] init];
    
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
    [self enableWithOptions:nil];
}

- (void)enableWithOptions:(CLUOptions *)options {
    if (!_isEnabled) {
        _isEnabled = YES;
        [self configureWithOptions:options];
    }
}

- (void)disable {
    if (_isEnabled) {
        _isEnabled = NO;
        // TODO: clear everything redundant
    }
}

- (void)configureWithOptions:(nullable CLUOptions *)options {
    if (!options) {
        options = [[CLUOptions alloc] init];        
    }
    _options = options;
}

- (void)handleException:(NSException *)exception {
    if (!exception || !_isEnabled || !_isRecording) {
        return;
    }
    
    NSURL *infoModulesDirectory = [[CLUReportFileManager sharedManager] infoModulesDirectoryURL];
    NSURL *outputURL = [infoModulesDirectory URLByAppendingPathComponent:@"info_exception.json"];
    JSONWriter *dataWriter = [[JSONWriter alloc] initWithOutputURL:outputURL];
    ExceptionInfoModule *exceptionModule = [[ExceptionInfoModule alloc] initWithWriter:dataWriter exception:exception];
    [exceptionModule recordInfoData];
    
    dispatch_sync(_waitVideoRenderingQueue, ^{
        [self stopRecording];
        [[CLUReportFileManager sharedManager] createZipReportFile];
        // Crazy hack! If exception occurs wait till video writer finish async handler -[AVAssetWriter finishWritingWithCompletionHandler]
        // TODO: come up with better approach
        [NSThread sleepForTimeInterval:4];
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
    UIViewController *currentViewController = [CLURecordIndicatorViewManager currentViewController];
    // If user has previous report file (caused by exception) suggest him to resend it
    if ([[CLUReportFileManager sharedManager] isReportZipFileAvailable]) {
        [self showAlertWithTitle:@"Send Previous Clue Report"
                         message:@"Do you want to send your previous Clue Report caused by internal excpetion?"
              successActionTitle:@"Send Report"
              failureActionTitle:@"Delete Report"
                  successHandler:^{
                      [self sendReportWithEmailService];
                  } failureHandler:^{
                      [[CLUReportFileManager sharedManager] removeReportZipFile];
                  }
                inViewController:currentViewController];
        return;
    }
    
    if (!_isRecording) {
        _isRecording = YES;
        [_reportComposer startRecording];
        NSDateComponents *maxTime = [CLURecordIndicatorViewManager defaultMaxTime];
        [CLURecordIndicatorViewManager showRecordIndicatorInViewController:currentViewController
                                                               withMaxTime:maxTime
                                                                    target:self
                                                                 andAction:@selector(stopRecording)];
    }
}

- (void)stopRecording {
    if (_isRecording) {
        _isRecording = NO;
        [_reportComposer stopRecording];
        
        [CLURecordIndicatorViewManager switchRecordIndicatorToWaitingMode];
        // Delay before zipping report, video rendering have to end properly
        ClueController __weak *weakSelf = self;
        dispatch_async(_waitVideoRenderingQueue, ^{
            // TODO: come up with better approach
            [NSThread sleepForTimeInterval:4];
            dispatch_sync(dispatch_get_main_queue(), ^{
                [CLURecordIndicatorViewManager hideRecordIndicator];
            });
            [weakSelf sendReportWithEmailService];
        });
    }
}

- (void)sendReportWithEmailService {
    UIViewController *currentViewController = [CLURecordIndicatorViewManager currentViewController];
    CLUMailHelper *mailHelper = [[CLUMailHelper alloc] initWithOption:_options];
     [mailHelper setMailDelegate:_mailDelegate];
    // TODO: test it on real device. Mail isn't working on simulator
    if (currentViewController) {
        [mailHelper showMailComposeWindowWithViewController:currentViewController];
    }
}

- (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
        successActionTitle:(NSString *)successActionTitle
        failureActionTitle:(NSString *)failureActionTitle
            successHandler:(void (^)())success
            failureHandler:(void (^)())failure
          inViewController:(UIViewController *)viewController {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *successAction = [UIAlertAction actionWithTitle:successActionTitle
                                                           style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * _Nonnull action) {
                                                             if (success) {
                                                                 success();
                                                             }
                                                         }];
    UIAlertAction *failureAction = [UIAlertAction actionWithTitle:failureActionTitle
                                                            style:UIAlertActionStyleCancel
                                                          handler:^(UIAlertAction * _Nonnull action) {
                                                              if (failure) {
                                                                  failure();
                                                              }
                                                          }];
    [alertController addAction:successAction];
    [alertController addAction:failureAction];
    [viewController presentViewController:alertController animated:YES completion:nil];
}

- (NSMutableArray *)configureRecordableModules {
    VideoModule *videoModule = [self configureVideoModule];
    ViewStructureModule *viewStructureModule = [self configureViewStructureModule];
    UserInteractionModule *userInteractionModule = [self configureUserInteractionModule];
    NetworkModule *networkModule = [self configureNetworkModule];
    
    NSMutableArray *modulesArray = [[NSMutableArray alloc] initWithObjects:videoModule,
                                    viewStructureModule,
                                    userInteractionModule,
                                    networkModule, nil];
    return modulesArray;
}

- (NSMutableArray *)configureInfoModules {
    DeviceInfoModule *deviceModule = [self configureDeviceInfoModule];
    NSMutableArray *modulesArray = [[NSMutableArray alloc] initWithObjects:deviceModule, nil];
    return modulesArray;
}

#pragma mark - Configure Recoradble modules

- (VideoModule *)configureVideoModule {
    NSURL *recordableModulesDirectory = [[CLUReportFileManager sharedManager] recordableModulesDirectoryURL];
    CGSize viewSize = [UIApplication sharedApplication].delegate.window.bounds.size;
    CGFloat viewScale = [UIScreen mainScreen].scale;
    NSURL *outputURL = [recordableModulesDirectory URLByAppendingPathComponent:@"module_video.mp4"];
    VideoWriter *videoWriter = [[VideoWriter alloc] initWithOutputURL:outputURL viewSize:viewSize viewScale:viewScale];
    VideoModule *videoModule = [[VideoModule alloc] initWithWriter:videoWriter];
    return videoModule;
}

- (ViewStructureModule *)configureViewStructureModule {
    NSURL *recordableModulesDirectory = [[CLUReportFileManager sharedManager] recordableModulesDirectoryURL];
    NSURL *outputURL = [recordableModulesDirectory URLByAppendingPathComponent:@"module_view.json"];
    JSONWriter *dataWriter = [[JSONWriter alloc] initWithOutputURL:outputURL];
    ViewStructureModule *viewStructureModule = [[ViewStructureModule alloc] initWithWriter:dataWriter];
    return viewStructureModule;
}

- (UserInteractionModule *)configureUserInteractionModule {
    NSURL *recordableModulesDirectory = [[CLUReportFileManager sharedManager] recordableModulesDirectoryURL];
    NSURL *outputURL = [recordableModulesDirectory URLByAppendingPathComponent:@"module_interaction.json"];
    JSONWriter *dataWriter = [[JSONWriter alloc] initWithOutputURL:outputURL];
    UserInteractionModule *userInteractionModule = [[UserInteractionModule alloc] initWithWriter:dataWriter];
    return userInteractionModule;
}

- (NetworkModule *)configureNetworkModule {
    NSURL *recordableModulesDirectory = [[CLUReportFileManager sharedManager] recordableModulesDirectoryURL];
    NSURL *outputURL = [recordableModulesDirectory URLByAppendingPathComponent:@"module_network.json"];
    JSONWriter *dataWriter = [[JSONWriter alloc] initWithOutputURL:outputURL];
    NetworkModule *networkModule = [[NetworkModule alloc] initWithWriter:dataWriter];
    return networkModule;
}

#pragma mark - Configure Info modules

- (DeviceInfoModule *)configureDeviceInfoModule {
    NSURL *infoModulesDirectory = [[CLUReportFileManager sharedManager] infoModulesDirectoryURL];
    NSURL *outputURL = [infoModulesDirectory URLByAppendingPathComponent:@"info_device.json"];
    JSONWriter *dataWriter = [[JSONWriter alloc] initWithOutputURL:outputURL];
    DeviceInfoModule *deviceModule = [[DeviceInfoModule alloc] initWithWriter:dataWriter];
    return deviceModule;
}

@end
