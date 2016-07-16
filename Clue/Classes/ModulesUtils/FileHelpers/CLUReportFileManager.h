//
//  CLUReportFileManager.h
//  Clue
//
//  Created by Ahmed Sulaiman on 7/9/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLUReportFileManager : NSObject

@property (nonatomic, readonly) NSURL *recordableModulesDirectoryURL;
@property (nonatomic, readonly) NSURL *infoModulesDirectoryURL;
@property (nonatomic, readonly) NSURL *reportDirectoryURL;
@property (nonatomic, readonly) NSURL *reportZipURL;

+ (instancetype)sharedManager;
- (BOOL)createReportFile;
- (BOOL)removeReportFile;
- (BOOL)removeReportZipFile;
- (BOOL)createZipReportFile;

@end
