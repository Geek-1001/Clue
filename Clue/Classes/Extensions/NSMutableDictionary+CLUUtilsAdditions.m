//
//  NSMutableDictionary+CLUUtilsAdditions.m
//  Clue
//
//  Created by Ahmed Sulaiman on 4/21/17.
//  Copyright © 2017 Ahmed Sulaiman. All rights reserved.
//

#import "NSMutableDictionary+CLUUtilsAdditions.h"

@implementation NSMutableDictionary (CLUUtilsAdditions)

- (void)clue_setValidObject:(nullable id)object forKey:(nonnull id)key {
    [self clue_setFilteredObject:object forKey:key withFilterBlock:^BOOL(id  _Nullable object) {
        return object != nil;
    }];
}

- (void)clue_setFilteredObject:(nullable id)object
                        forKey:(nonnull id<NSCopying>)key
               withFilterBlock:(BOOL (^ _Nonnull)(id _Nullable object))filterBlock {
    if (!filterBlock) {
        return;
    }
    BOOL filterValue = filterBlock(object);
    if (filterValue) {
        [self setObject:object forKey:key];
    }
}

@end
