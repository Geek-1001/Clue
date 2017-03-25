//
//  CLUOptions.h
//  Clue
//
//  Created by Ahmed Sulaiman on 5/11/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 `CLUOptions` is a data model class to store all configurational variables during Clue framework setup and enable process.
 For now only `email` property is available. 
 If you need more configurational property which could be used during first setup - just subclass this class
 
 Used in `ClueController` configuration
 @code [[ClueController sharedInstance] enableWithOptions:<CLUOptions here>];
 */
@interface CLUOptions : NSObject

/**
 Email address where user will send an email with recorded report attached to it.
 */
@property (nonatomic) NSString *email;

/**
 Create new `CLUOptions` instance with email adress
 
 @param email Email address where user will send an email with recorder report in attachment.
 
 @return instance of `CLUOptions`
 */
+ (instancetype)initWithEmail:(NSString *)email;

@end
