//
//  CLUOptions.h
//  Clue
//
//  Created by Ahmed Sulaiman on 5/11/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLUOptions : NSObject

@property (nonatomic) NSString *email;

+ (instancetype)initWithEmail:(NSString *)email;

@end
