//
//  CLUMailDelegate.h
//  Clue
//
//  Created by Ahmed Sulaiman on 7/17/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>

/**
 `CLUMailDelegate` is delegate class to handle responses/events from mail composer modal view.
 For report mail sending. If mail sending was successful - remove old report .clue file and report .zip file
 */
@interface CLUMailDelegate : NSObject <MFMailComposeViewControllerDelegate>

@end
