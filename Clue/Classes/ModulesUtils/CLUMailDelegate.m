//
//  CLUMailDelegate.m
//  Clue
//
//  Created by Ahmed Sulaiman on 7/17/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import "CLUMailDelegate.h"
#import "CLUReportFileManager.h"

@implementation CLUMailDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(nullable NSError *)error {
    switch (result) {
        case MFMailComposeResultSent:
            // Remove old report file in case of successful mail sending
            [[CLUReportFileManager sharedManager] removeReportFile];
            [[CLUReportFileManager sharedManager] removeReportZipFile];
            break;
            
        case MFMailComposeResultCancelled:
        case MFMailComposeResultSaved:
        case MFMailComposeResultFailed:
            break;
    }

    [controller dismissViewControllerAnimated:YES completion:nil];
}

@end
