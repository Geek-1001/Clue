//
//  CLUReportFileManager.h
//  Clue
//
//  Created by Ahmed Sulaiman on 7/9/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 `CLUReportFileManager` is a singleton class responsible for managing final report .clue file and interact which it on file system level
 
 .clue file is a package consists of two subdirectories `Info` and `Modules`
 `Info` directory contains all static modules like: info_device.json (with statis device information)
 `Modules` directory contains all real-time, recordable modules like: module_interaction.json (with all user touches), module_network.json (with all network communications), module_view.json (with all view mutation), module_video.mp4 (with screen cast).
 */
@interface CLUReportFileManager : NSObject

/**
 URL of recordable modules directory `Modules` inside .clue package file
 
 @warning Client can't change this value, it configures during first `CLUReportFileManager` initialization
 */
@property (nonatomic, readonly) NSURL *recordableModulesDirectoryURL;

/**
 URL of static modules directory `Info` inside .clue package file
 
 @warning Client can't change this value, it configures during first `CLUReportFileManager` initialization
 */
@property (nonatomic, readonly) NSURL *infoModulesDirectoryURL;

/**
 URL of final .clue file which located in tmp directory of current application
 
 @warning Client can't change this value, it configures during first `CLUReportFileManager` initialization
 */
@property (nonatomic, readonly) NSURL *reportDirectoryURL;

/**
 URL of .clue zip file which located in tmp directory of current application.
 Used for email attachment after successful recording
 
 @warning Client can't change this value, it configures during first `CLUReportFileManager` initialization
 */
@property (nonatomic, readonly) NSURL *reportZipURL;

/**
 Returns the shared singleton instance of `CLUReportFileManager`

 @return Shared singleton instance of `CLUReportFileManager`
 */
+ (instancetype)sharedManager;

/**
 Create new report file with UUID as a name and with configured structure (with created Modules and Info subdirectories)

 @return BOOL values that indicated whether report file creation was successful or not
 */
- (BOOL)createReportFile;

/**
 Remove report file with all subdirectories inside

 @return BOOL values that indicated whether report file removal was successful or not
 */
- (BOOL)removeReportFile;

/**
 Remove zip file with report inside

 @return BOOL values that indicated whether report file removal was successful or not
 */
- (BOOL)removeReportZipFile;

/**
 Create zip archive file with .clue report file inside

 @return BOOL values that indicated whether report file removal was successful or not
 */
- (BOOL)createZipReportFile;

/**
 Check if report zip file is available at `CLUReportFileManager.reportZipURL`

 @return BOOL values that indicated whether report file exists at `CLUReportFileManager.reportZipURL` or not
 */
- (BOOL)isReportZipFileAvailable;

@end
