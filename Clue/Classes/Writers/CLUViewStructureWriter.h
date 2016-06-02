//
//  CLUViewStructureWriter.h
//  Clue
//
//  Created by Ahmed Sulaiman on 5/31/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLUWritable.h"

@interface CLUViewStructureWriter : NSObject <CLUWritable, NSStreamDelegate>

@property (nonatomic, readonly) NSURL *outputURL;

- (instancetype)initWithOutputURL:(NSURL *)outputURL;
- (void)addViewStructureProperties:(NSDictionary *)propertiesDictionary withTimeInterval:(CFTimeInterval)timeInterval;

@end
