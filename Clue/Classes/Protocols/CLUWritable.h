//
//  CLUWritable.h
//  Clue
//
//  Created by Ahmed Sulaiman on 5/18/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CLUWritable <NSObject>

@required
- (BOOL)isReadyForWriting;
- (void)finishWriting;
- (void)startWriting;

@end
