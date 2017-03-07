//
//  CLUViewStructureWriter.m
//  Clue
//
//  Created by Ahmed Sulaiman on 5/31/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import "CLUViewStructureWriter.h"

#define DEFAULT_TIMESTAMP_KEY @"timestamp"
#define DEFAULT_VIEW_KEY @"view"

@implementation CLUViewStructureWriter

- (instancetype)initWithOutputURL:(NSURL *)outputURL {
    self = [super initWithOutputURL:outputURL];
    if (!self) {
        return nil;
    }
    return self;
}

- (void)addViewStructureProperties:(NSDictionary *)propertiesDictionary
                            forKey:(NSString *)viewKey
                  withTimeInterval:(CFTimeInterval)timeInterval
                            forKey:(NSString *)timestampKey {
    if (!propertiesDictionary) {
        return;
    }
    
    NSMutableDictionary *rootViewDictionary = [[NSMutableDictionary alloc] init];
    [rootViewDictionary setValue:[NSNumber numberWithDouble:timeInterval] forKey:timestampKey];
    [rootViewDictionary setValue:propertiesDictionary forKey:viewKey];
    
    NSError *error;
    BOOL isPropertiesDictionaryValid = [NSJSONSerialization isValidJSONObject:rootViewDictionary];
    if (!isPropertiesDictionaryValid) {
        // TODO: notify about error
        return;
    }
    NSData *viewPropertiesData = [NSJSONSerialization dataWithJSONObject:rootViewDictionary options:0 error:&error];
    [self addData:viewPropertiesData];
    
}

- (void)addViewStructureProperties:(NSDictionary *)propertiesDictionary withTimeInterval:(CFTimeInterval)timeInterval {
    [self addViewStructureProperties:propertiesDictionary
                              forKey:DEFAULT_VIEW_KEY
                    withTimeInterval:timeInterval
                              forKey:DEFAULT_TIMESTAMP_KEY];
}

@end
