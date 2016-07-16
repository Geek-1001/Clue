//
//  CLUReportFileManager.m
//  Clue
//
//  Created by Ahmed Sulaiman on 7/9/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import "CLUReportFileManager.h"
#import "SSZipArchive.h"

@implementation CLUReportFileManager

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    NSString *reportFileName = [self currentReportFileName];
    _reportDirectoryURL = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:reportFileName]
                                     isDirectory:YES];
    _reportZipURL = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"report.clue.zip"]
                               isDirectory:NO];
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
    return [self removeFileWithURL:_reportDirectoryURL];
}

- (BOOL)removeReportZipFile {
    return [self removeFileWithURL:_reportZipURL];
}

- (BOOL)removeFileWithURL:(NSURL *)fileURL {
    BOOL status = NO;
    if (fileURL) {
        NSError *error;
        status = [[NSFileManager defaultManager] removeItemAtURL:fileURL error:&error];
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

- (BOOL)createZipReportFile {
    NSString *reportPath = [_reportDirectoryURL path];
    NSString *reportZipPath = [_reportZipURL path];
    BOOL status = [SSZipArchive createZipFileAtPath:reportZipPath withContentsOfDirectory:reportPath];
    
    return status;
}

@end
