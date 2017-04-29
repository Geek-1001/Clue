//
//  CLUExceptionInfoModule.m
//  Clue
//
//  Created by Ahmed Sulaiman on 7/12/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import "CLUExceptionInfoModule.h"
#import "NSException+CLUExceptionAdditions.h"

#import <Clue/Clue-Swift.h>

@interface CLUExceptionInfoModule()
@property (nonatomic) JSONWriter *writer;
@end

@implementation CLUExceptionInfoModule

- (instancetype)initWithWriter:(JSONWriter *)writer {
    self = [super init];
    if (!self || !writer) {
        return nil;
    }
    _writer = writer;
    return self;
}

- (void)recordInfoData {
    if (!_exception) {
        return;
    }
    
    NSDictionary *exceptionProperties = [_exception clue_exceptionProperties];
    [_writer startWriting];
    [_writer appendWithJson:exceptionProperties];
    [_writer finishWriting];
}

@end
