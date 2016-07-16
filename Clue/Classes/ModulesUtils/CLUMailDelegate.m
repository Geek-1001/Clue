//
//  CLUMailDelegate.m
//  Clue
//
//  Created by Ahmed Sulaiman on 7/17/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import "CLUMailDelegate.h"

@implementation CLUMailDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(nullable NSError *)error {
    // TODO: handle mail response
    switch (result) {
        case MFMailComposeResultCancelled:
            break;
            
        case MFMailComposeResultSaved:
            break;
            
        case MFMailComposeResultSent:
            break;
            
        case MFMailComposeResultFailed:
            break;
            
        default:
            break;
    }
}

@end
