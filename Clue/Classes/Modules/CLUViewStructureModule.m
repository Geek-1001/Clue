//
//  CLUViewStructureModule.m
//  Clue
//
//  Created by Ahmed Sulaiman on 5/26/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import "CLUViewStructureModule.h"
#import "UIView+CLUViewRecordableAdditions.h"
#import <UIKit/UIKit.h>

#define DEFAULT_VIEW_KEY @"view"

@interface CLUViewStructureModule()

@property (nonatomic) NSDictionary *lastRecordedViewStructure;

@end

@implementation CLUViewStructureModule

#pragma mark - View Structure Encoding

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

#pragma mark - Recordable Module Delegate

- (void)addNewFrameWithTimestamp:(CFTimeInterval)timestamp {
    @synchronized (self) {
        NSDictionary *currentViewStructure;
        for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
            UIViewController *rootViewController = window.rootViewController;
            if (rootViewController) {
                if ([rootViewController.view class] == [UIView class]) {
                    currentViewStructure = [rootViewController.view clue_viewPropertiesDictionary];
                }
            }
        }
        if (!_lastRecordedViewStructure || ![_lastRecordedViewStructure isEqualToDictionary:currentViewStructure]) {
            [self addViewStructureProperties:currentViewStructure
                                      forKey:DEFAULT_VIEW_KEY
                            withTimeInterval:timestamp
                                      forKey:TIMESTAMP_KEY];
            _lastRecordedViewStructure = currentViewStructure;
        }
        [super addNewFrameWithTimestamp:timestamp];
    }
}

@end
