//
//  CLUInfoModule.h
//  Clue
//
//  Created by Ahmed Sulaiman on 7/9/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLUWritable.h"

@protocol CLUInfoModule <NSObject>

@required
- (instancetype)initWithWriter:(id <CLUWritable>)writer;
- (void)recordInfoData;

@end
