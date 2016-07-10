//
//  CLUReportFileManager.m
//  Clue
//
//  Created by Ahmed Sulaiman on 7/9/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import "CLUReportFileManager.h"

@implementation CLUReportFileManager

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    NSString *reportFileName = [self currentReportFileName];
    _reportDirectoryURL = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:reportFileName]
                                     isDirectory:YES];
    _recordableModulesDirectoryURL = [_reportDirectoryURL URLByAppendingPathComponent:@"Modules" isDirectory:YES];
    _infoModulesDirectoryURL = [_reportDirectoryURL URLByAppendingPathComponent:@"Info" isDirectory:YES];
    return self;
}

+ (instancetype)sharedManager {
    static CLUReportFileManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (BOOL)createReportFile {
    for (NSURL *currentURL in @[_reportDirectoryURL, _recordableModulesDirectoryURL, _infoModulesDirectoryURL]) {
        NSError *error;
        BOOL status = [[NSFileManager defaultManager] createDirectoryAtURL:currentURL
                                               withIntermediateDirectories:YES
                                                                attributes:nil
                                                                     error:&error];
        if (!status || error) {
            return status;
        }
    }
    return YES;
}

- (BOOL)removeReportFile {
    BOOL status = NO;
    if (_reportDirectoryURL) {
        NSError *error;
        status = [[NSFileManager defaultManager] removeItemAtURL:_reportDirectoryURL error:&error];
    }
    return status;
}

- (NSString *)currentReportFileName {
    NSMutableString *reportName = [[NSMutableString alloc] init];
    NSString *UUID = [[NSUUID UUID] UUIDString];
    [reportName setString:UUID];
    [reportName appendString:@".clue"];
    return reportName;
}

@end
