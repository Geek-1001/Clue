//
//  CLUViewStructureModule.h
//  Clue
//
//  Created by Ahmed Sulaiman on 5/26/16.
//  Copyright © 2016 Ahmed Sulaiman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CLUObserveModule.h"

/**
 `CLUViewStructureModule` is a subclass of `CLUObserveModule` for view hierarchy recording for any specific time. It will record all views currently present on the top view controller (properties of those views and their subviews as well). Also `CLUViewStructureModule` keep track of last recorded view structure so it won't record same view structure twice.
 */
@interface CLUViewStructureModule : CLUObserveModule

@end
