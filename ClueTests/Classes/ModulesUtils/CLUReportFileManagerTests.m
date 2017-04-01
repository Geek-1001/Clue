//
//  CLUReportFileManagerTests.m
//  Clue
//
//  Created by Ahmed Sulaiman on 4/1/17.
//  Copyright © 2017 Ahmed Sulaiman. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "CLUReportFileManager.h"

@interface CLUReportFileManagerTests : XCTestCase
@property (nonatomic) CLUReportFileManager *reportFileManager;
@property (nonatomic) NSFileManager *fileManager;
@end

@implementation CLUReportFileManagerTests

- (void)setUp {
    [super setUp];
    _reportFileManager = [CLUReportFileManager sharedManager];
    _fileManager = [NSFileManager defaultManager];
}

- (void)tearDown {
    _reportFileManager = nil;
    _fileManager = nil;
    [super tearDown];
}

- (void)testRecordableModulesDirectoryURL {
    NSURL *recordableModulesURL = _reportFileManager.recordableModulesDirectoryURL;
    XCTAssertNotNil(recordableModulesURL, @"Recordable Modules Directory URL is invalid");
    XCTAssertTrue([recordableModulesURL hasDirectoryPath], @"Recordable Modules Directory URL should be a directory");
    XCTAssertEqualObjects(recordableModulesURL.path.lastPathComponent, @"Modules", @"Recordable Modules Directory URL should have Modules as a last path component");
}

- (void)testInfoModulesDirectoryURL {
    NSURL *infoModulesURL = _reportFileManager.infoModulesDirectoryURL;
    XCTAssertNotNil(infoModulesURL, @"Info Modules Directory URL is invalid");
    XCTAssertTrue([infoModulesURL hasDirectoryPath], @"Info Modules Directory URL should be a directory");
    XCTAssertEqualObjects(infoModulesURL.path.lastPathComponent, @"Info", @"Info Modules Directory URL should have Info as a last path component");
}

- (void)testReportDirectoryURL {
    NSURL *reportURL = _reportFileManager.reportDirectoryURL;
    XCTAssertNotNil(reportURL, @"Report Directory URL is invalid");
    XCTAssertTrue([reportURL hasDirectoryPath], @"Report Directory URL should be a directory");
    XCTAssertEqualObjects(reportURL.path.lastPathComponent.pathExtension, @"clue", @"Report Directory URL should point on clue file");
}

- (void)testReportZipURL {
    NSURL *reportZipURL = _reportFileManager.reportZipURL;
    XCTAssertNotNil(reportZipURL, @"Report Zip file URL is invalid");
    XCTAssertTrue([reportZipURL isFileURL], @"Report Zip file URL should be a file");
    XCTAssertEqualObjects(reportZipURL.path.lastPathComponent, @"report.clue.zip", @"Report Zip file URL should have name report.clue.zip");
}

- (void)testCreateAndRemoveReportFile {
    // Test report creation
    BOOL isReportFileCreated = [_reportFileManager createReportFile];
    XCTAssertTrue(isReportFileCreated, @"Report file creation result should be true");
    
    // Test if the file actually exists at given path
    NSString *reportFilePath = _reportFileManager.reportDirectoryURL.path;
    BOOL isReportFileExists = [_fileManager fileExistsAtPath:reportFilePath];
    XCTAssertTrue(isReportFileExists, @"Report file should exists at path %@", reportFilePath);
    
    // Test Report file removal
    BOOL isReportFileRemoved = [_reportFileManager removeReportFile];
    XCTAssertTrue(isReportFileRemoved, @"Report file removal result should be true");
    
    // Test again if the file actually exists at given path
    isReportFileExists = [_fileManager fileExistsAtPath:reportFilePath];
    XCTAssertFalse(isReportFileExists, @"Report file should not exists at path %@", reportFilePath);
}

- (void)testCreateAndRemoveReportZipFile {
    // Test report zip file creation
    BOOL isReportZipFileCreated = [_reportFileManager createZipReportFile];
    XCTAssertTrue(isReportZipFileCreated, @"Report zip file creation result should be true");
    
    // Test if zip file actually exists at given path
    NSString *zipFilePath = _reportFileManager.reportZipURL.path;
    BOOL isReportZipFileExists = [_fileManager fileExistsAtPath:zipFilePath];
    XCTAssertTrue(isReportZipFileExists, @"Report zip file should exists at path %@ after creation", zipFilePath);
    
    // Test Report zip file availablity after creation
    BOOL isReportZipFileAvailable = [_reportFileManager isReportZipFileAvailable];
    XCTAssertTrue(isReportZipFileAvailable, @"Report zip file should be available at path %@ after creation", zipFilePath);
    
    // Test Report zip file removal
    BOOL isReportZipFileRemoved = [_reportFileManager removeReportZipFile];
    XCTAssertTrue(isReportZipFileRemoved, @"Report zip file removal result should be true");
    
    // Test again if zip file actually exists at given path after removal
    isReportZipFileExists = [_fileManager fileExistsAtPath:zipFilePath];
    XCTAssertFalse(isReportZipFileExists, @"Report zip file should not exists at path %@ after removal", zipFilePath);
    
    // Test again Report zip file availablity after removal
    isReportZipFileAvailable = [_reportFileManager isReportZipFileAvailable];
    XCTAssertFalse(isReportZipFileAvailable, @"Report zip file should not be available at path %@ after removal", zipFilePath);
}

@end
