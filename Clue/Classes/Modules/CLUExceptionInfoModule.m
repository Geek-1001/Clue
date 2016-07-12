//
//  CLUExceptionInfoModule.m
//  Clue
//
//  Created by Ahmed Sulaiman on 7/12/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import "CLUExceptionInfoModule.h"
#import "CLUDataWriter.h"
#import "NSException+CLUExceptionAdditions.h"

@interface CLUExceptionInfoModule()
@property (nonatomic) CLUDataWriter *writer;
@end

@implementation CLUExceptionInfoModule

- (instancetype)initWithWriter:(CLUDataWriter *)writer {
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
    if ([NSJSONSerialization isValidJSONObject:exceptionProperties]) {
        NSError *error;
        NSData *exceptionData = [NSJSONSerialization dataWithJSONObject:exceptionProperties options:0 error:&error];
        if (!error && exceptionData) {
            [_writer startWriting];
            [_writer addData:exceptionData];
            [_writer finishWriting];
        }
    } else {
        NSLog(@"Exception properties json is invalid");
    }
}

@end
