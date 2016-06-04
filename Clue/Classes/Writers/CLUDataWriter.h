//
//  CLUDataWriter.h
//  Clue
//
//  Created by Ahmed Sulaiman on 6/4/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLUWritable.h"

@interface CLUDataWriter : NSObject <CLUWritable, NSStreamDelegate>

@property (nonatomic, readonly) NSURL *outputURL;

- (instancetype)initWithOutputURL:(NSURL *)outputURL;
- (void)addData:(NSData *)data;

@end
