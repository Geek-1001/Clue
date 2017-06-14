//
//  CLUMailHelper.m
//  Clue
//
//  Created by Ahmed Sulaiman on 7/12/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import "CLUMailHelper.h"
#import "CLUReportFileManager.h"

@interface CLUMailHelper()

@property (nonatomic) MFMailComposeViewController *mailComposeViewController;

@end

@implementation CLUMailHelper

- (instancetype)initWithOptions:(CLUOptions *)options {
    self = [super init];
    if (!self || !options) {
        return nil;
    }
    _mailComposeViewController = [[MFMailComposeViewController alloc] init];
    NSString *currentReportSubject = [self currentReportSubject];
    [_mailComposeViewController setSubject:currentReportSubject];
    if (options.email) {
        [_mailComposeViewController setToRecipients:@[options.email]];
    }
    BOOL isZipFileCreatedSuccessfully = [[CLUReportFileManager sharedManager] createZipReportFile];
    if (isZipFileCreatedSuccessfully) {
        NSURL *reportZipURL = [[CLUReportFileManager sharedManager] reportZipURL];
        NSData *reportZipData = [NSData dataWithContentsOfURL:reportZipURL];
        if (reportZipData) {
            [_mailComposeViewController addAttachmentData:reportZipData mimeType:@"application/zip" fileName:@"report.clue.zip"];
        }
    }
    
    return self;
}

- (void)showMailComposeWindowWithViewController:(UIViewController *)viewController {
    if ([MFMailComposeViewController canSendMail]) {
        [viewController presentViewController:_mailComposeViewController animated:YES completion:nil];
    }
}

- (void)setMailDelegate:(id <MFMailComposeViewControllerDelegate>)delegate {
    if (delegate) {
        [_mailComposeViewController setMailComposeDelegate:delegate];
    }
}

- (NSString *)currentReportSubject {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *currentDate = [NSDate date];
    NSString *currentDateString = [formatter stringFromDate:currentDate];
    NSString *subject = [[NSString alloc] initWithFormat:@"Clue Bug Report %@", currentDateString];
    return subject;
}

@end
