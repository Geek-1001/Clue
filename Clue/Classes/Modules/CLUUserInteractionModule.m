//
//  CLUUserInteractionModule.m
//  Clue
//
//  Created by Ahmed Sulaiman on 6/4/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import "CLUUserInteractionModule.h"
#import "CLUGeneralGestureRecognizer.h"

#import <Clue/Clue-Swift.h>

#define kTOUCH_BEGAN_EVENT @"Began"
#define kTOUCH_MOVED_EVENT @"Moved"
#define kTOUCH_ENDED_EVENT @"Ended"

@interface CLUUserInteractionModule()

@property (nonatomic) CLUGeneralGestureRecognizer *gestureRecognizer;

@end

@implementation CLUUserInteractionModule

- (instancetype)initWithWriter:(JSONWriter *)writer {
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
        [[[UIApplication sharedApplication] keyWindow] addGestureRecognizer:_gestureRecognizer];
    }
}

- (void)stopRecording {
    if (self.isRecording) {
        [super stopRecording];
        [[[UIApplication sharedApplication] keyWindow] removeGestureRecognizer:_gestureRecognizer];
        [_gestureRecognizer removeObserverDelegate];
    }
}

- (void)touchesBegan:(NSArray<CLUTouch *> *)touches {
    [self addOneTimeTouchs:touches forType:kTOUCH_BEGAN_EVENT];
}

- (void)touchesMoved:(NSArray<CLUTouch *> *)touches {
    [self addOneTimeTouchs:touches forType:kTOUCH_MOVED_EVENT];
}

- (void)touchesEnded:(NSArray<CLUTouch *> *)touches {
    [self addOneTimeTouchs:touches forType:kTOUCH_ENDED_EVENT];
}

- (void)addOneTimeTouchs:(NSArray<CLUTouch *> *)touches forType:(nonnull NSString *)type {
    @synchronized (self) {
        NSMutableDictionary *touchDictionary = [[NSMutableDictionary alloc] init];
        [touchDictionary setObject:type forKey:@"type"];
        [touchDictionary setObject:@(self.currentTimeStamp) forKey:TIMESTAMP_KEY];
        
        NSMutableArray *touchArray = [[NSMutableArray alloc] init];
        for (CLUTouch *touch in touches) {
            NSDictionary *touchPropertiesDictionary = [touch properties];
            [touchArray addObject:touchPropertiesDictionary];
        }
        [touchDictionary setObject:touchArray forKey:@"touches"];
        
        [self addData:touchDictionary];
    }
}

@end
