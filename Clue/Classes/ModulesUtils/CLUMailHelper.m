//
//  CLUMailHelper.m
//  Clue
//
//  Created by Ahmed Sulaiman on 7/12/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import "CLUMailHelper.h"

@interface CLUMailHelper()

@property (nonatomic) MFMailComposeViewController *mailComposeViewController;

@end

@implementation CLUMailHelper

- (instancetype)initWithOption:(CLUOptions *)option {
    self = [super init];
    if (!self || !option) {
        return nil;
    }
    _mailComposeViewController = [[MFMailComposeViewController alloc] init];
    NSString *currentReportSubject = [self currentReportSubject];
    [_mailComposeViewController setSubject:currentReportSubject];
    if (option.email) {
        [_mailComposeViewController setToRecipients:@[option.email]];
    }
    // TODO: set attachment. Make zip and attach
    
    return self;
}

- (void)showMailComposeWindow {
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    if (!keyWindow) {
        return;
    }
    UIViewController *viewController = [keyWindow rootViewController];
    if (!viewController) {
        return;
    }
    [viewController presentViewController:_mailComposeViewController animated:YES completion:nil];
}

- (void)setMailDelegate:(id <MFMailComposeViewControllerDelegate>)delegate {
    if (delegate) {
        [_mailComposeViewController setMailComposeDelegate:delegate];
    }
}

- (NSString *)currentReportSubject {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-DD HH:SS"];
    NSDate *currentDate = [NSDate date];
    NSString *currentDateString = [formatter stringFromDate:currentDate];
    NSString *subject = [[NSString alloc] initWithFormat:@"Clue Bug Report %@", currentDateString];
    return subject;
}

@end
