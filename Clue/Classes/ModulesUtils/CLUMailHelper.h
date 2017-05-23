//
//  CLUMailHelper.h
//  Clue
//
//  Created by Ahmed Sulaiman on 7/12/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>
#import "CLUOptions.h"

/**
 `CLUMailHelper` is class responsible for mail sending process. Set mail subject, add .clue report zip file in attachment and show mail compose modal view for specific viewController
 */
@interface CLUMailHelper : NSObject

/**
 Create new instance of `CLUMailHelper` with configured options (which contains email where `CLUMailHelper` will send mail with .clue report)
 
 @param option `CLUOptions` object which contains email property where `CLUMailHelper` will send mail with .clue report. Get this options from first Clue Controller configuration
 @return `CLUMailHelper` instance with configure options
 */
- (instancetype)initWithOptions:(CLUOptions *)options;

/**
 Show mail composer modal view for specific view controller

 @param viewController `UIViewController` where `CLUMailHelper` will show mail composer modal view
 */
- (void)showMailComposeWindowWithViewController:(UIViewController *)viewController;

/**
 Set `MFMailComposeViewControllerDelegate` delegate object

 @param delegate `MFMailComposeViewControllerDelegate` delegate object to handle responses/events from mail composer view
 */
- (void)setMailDelegate:(id <MFMailComposeViewControllerDelegate>)delegate;

@end
