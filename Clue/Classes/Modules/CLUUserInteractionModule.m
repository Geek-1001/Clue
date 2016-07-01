//
//  CLUUserInteractionModule.m
//  Clue
//
//  Created by Ahmed Sulaiman on 6/4/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import "CLUUserInteractionModule.h"
#import "CLUDataWriter.h"
#import "CLUGeneralGestureRecognizer.h"

@interface CLUUserInteractionModule()

@property (nonatomic) CLUGeneralGestureRecognizer *gestureRecognizer;

@end

@implementation CLUUserInteractionModule

- (instancetype)initWithWriter:(CLUDataWriter *)writer {
    self = [super initWithWriter:writer];
    if (!self) {
        return nil;
    }
    _gestureRecognizer = [[CLUGeneralGestureRecognizer alloc] init];
    return self;
}

- (void)startRecording {
    if (!self.isRecording) {
        [super startRecording];
        [_gestureRecognizer setObserverDelegate:self];
        #warning If some window will be destroyed how to deattach gesture recognizer from it? Possible memory leak!
        for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
            [window addGestureRecognizer:_gestureRecognizer];
        }
    }
}

- (void)stopRecording {
    if (self.isRecording) {
        [super isRecording];
        for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
            [window removeGestureRecognizer:_gestureRecognizer];
        }
        [_gestureRecognizer removeObserverDelegate];
    }
}

- (void)touchesBegan:(NSArray<CLUTouch *> *)touches {
    // TODO: set touch type value as a const string
    [self addOneTimeTouchs:touches forType:@"began"];
}

- (void)touchesMoved:(NSArray<CLUTouch *> *)touches {
    [self addOneTimeTouchs:touches forType:@"moved"];
}

- (void)touchesEnded:(NSArray<CLUTouch *> *)touches {
    [self addOneTimeTouchs:touches forType:@"ended"];
}

- (void)addOneTimeTouchs:(NSArray<CLUTouch *> *)touches forType:(nonnull NSString *)type {
    @synchronized (self) {
        NSMutableDictionary *touchDictionary = [[NSMutableDictionary alloc] init];
        [touchDictionary setObject:type forKey:@"type"];
        [touchDictionary setObject:@(self.currentTimeStamp) forKey:@"timestamp"];
        
        NSMutableArray *touchArray = [[NSMutableArray alloc] init];
        for (CLUTouch *touch in touches) {
            NSDictionary *touchPropertiesDictionary = [touch properties];
            [touchArray addObject:touchPropertiesDictionary];
        }
        [touchDictionary setObject:touchArray forKey:@"touches"];
        
        if ([NSJSONSerialization isValidJSONObject:touchDictionary]) {
            NSError *error;
            NSData *touchData = [NSJSONSerialization dataWithJSONObject:touchDictionary options:0 error:&error];
            [self addData:touchData];
        } else {
            NSLog(@"Touch properties json is invalid");
        }
    }
}

@end
