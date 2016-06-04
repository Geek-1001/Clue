//
//  CLUViewStructureWriter.m
//  Clue
//
//  Created by Ahmed Sulaiman on 5/31/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import "CLUViewStructureWriter.h"

@implementation CLUViewStructureWriter

- (instancetype)initWithOutputURL:(NSURL *)outputURL {
    self = [super initWithOutputURL:outputURL];
    if (!self) {
        return nil;
    }
    return self;
}

- (void)addViewStructureProperties:(NSDictionary *)propertiesDictionary withTimeInterval:(CFTimeInterval)timeInterval {
    if (!propertiesDictionary) {
        return;
    }
    
    NSMutableDictionary *rootViewDictionary = [[NSMutableDictionary alloc] init];
    [rootViewDictionary setValue:[NSNumber numberWithDouble:timeInterval] forKey:@"timeInterval"];
    [rootViewDictionary setValue:propertiesDictionary forKey:@"view"];
    
    NSError *error;
    BOOL isPropertiesDictionaryValid = [NSJSONSerialization isValidJSONObject:rootViewDictionary];
    if (!isPropertiesDictionaryValid) {
        // TODO: notify about error
        return;
    }
    NSData *viewPropertiesData = [NSJSONSerialization dataWithJSONObject:rootViewDictionary options:0 error:&error];
    [self addData:viewPropertiesData];
}

@end
