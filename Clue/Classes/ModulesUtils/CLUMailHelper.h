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

@interface CLUMailHelper : NSObject

- (instancetype)initWithOption:(CLUOptions *)option;
- (void)showMailComposeWindowWithViewController:(UIViewController *)viewController;
- (void)setMailDelegate:(id <MFMailComposeViewControllerDelegate>)delegate;

@end
