//
//  CLUDeviceInfoModule.m
//  Clue
//
//  Created by Ahmed Sulaiman on 7/9/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import "CLUDeviceInfoModule.h"
#import <UIKit/UIKit.h>
#import "NSMutableDictionary+CLUUtilsAdditions.h"

#import <Clue/Clue-Swift.h>

@interface CLUDeviceInfoModule()
@property (nonatomic) JSONWriter *writer;
@end

@implementation CLUDeviceInfoModule

- (instancetype)initWithWriter:(JSONWriter *)writer {
    self = [super init];
    if (!self || !writer) {
        return nil;
    }
    _writer = writer;
    return self;
}

- (void)recordInfoData {
    NSDictionary *deviceProperties = [self deviceProperties];
    [_writer startWriting];
    [_writer appendWithJson:deviceProperties];
    [_writer finishWriting];
}

- (NSDictionary *)deviceProperties {
    NSMutableDictionary *deviceProperties = [[NSMutableDictionary alloc] init];
    UIDevice *device = [UIDevice currentDevice];
    
    [deviceProperties setObject:device.name forKey:@"name"];
    [deviceProperties setObject:device.systemName forKey:@"systemName"];
    [deviceProperties setObject:device.systemVersion forKey:@"systemVersion"];
    [deviceProperties setObject:device.model forKey:@"model"];
    [deviceProperties clue_setValidObject:[device.identifierForVendor UUIDString] forKey:@"identifierForVendor"];
    [deviceProperties setObject:@(device.batteryLevel) forKey:@"batteryLevel"];
    [deviceProperties setObject:@(device.batteryState) forKey:@"batteryState"];
    
    return deviceProperties;
}

@end
