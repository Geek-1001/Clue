//
//  CLUViewStructureModule.h
//  Clue
//
//  Created by Ahmed Sulaiman on 5/26/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLURecordableModule.h"

@interface CLUViewStructureModule : NSObject <CLURecordableModule>

@property (nonatomic, readonly) BOOL isRecording;

@end
