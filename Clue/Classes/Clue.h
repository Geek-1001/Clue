//
//  Clue.h
//  Clue
//
//  Created by Ahmed Sulaiman on 5/11/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLUOptions.h"

static char* ClueAssociationKey = "ClueAssociationKey";

@interface Clue : NSObject {
    @private
    BOOL _isEnabled;
    BOOL _isRecording;
}

- (instancetype)initWithWindow:(UIWindow *)window;
- (BOOL)startRecord;
- (BOOL)stopRecord;

- (void)enable;
- (void)enableWithOptions:(CLUOptions *)options;


@end
