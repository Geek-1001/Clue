//
//  AppDelegate.m
//  ClueExampleApp
//
//  Created by Ahmed Sulaiman on 4/30/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import "AppDelegate.h"
#import <Clue/Clue.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[ClueController shared] enableWith:[CLUOptions optionsWithEmail:@"ahmed.sulajman@gmail.com"]];
    return YES;
}

// motionBegan: don't work in AppDelegate for iOS 10 +
/*
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    [[ClueController sharedInstance] handleShake:motion];
}
*/

@end
