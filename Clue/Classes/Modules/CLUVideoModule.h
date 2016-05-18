//
//  CLUVideoModule.h
//  Clue
//
//  Created by Ahmed Sulaiman on 5/18/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CLURecordableModule.h"
#import "CLUVideoWriter.h"

@interface CLUVideoModule : NSObject <CLURecordableModule>

@property (nonatomic, readonly) BOOL isRecording;

@end
