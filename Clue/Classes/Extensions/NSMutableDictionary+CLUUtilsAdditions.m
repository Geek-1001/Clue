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

- (void)clue_setValidAndNotEmptyString:(nullable NSString *)string forKey:(nonnull id)key {
    [self clue_setValidAndNotEmptyObject:string forKey:key];
}

- (void)clue_setValidAndNotEmptyDictionary:(nullable NSDictionary *)dictionary forKey:(nonnull id)key {
    [self clue_setValidAndNotEmptyObject:dictionary forKey:key];
}

- (void)clue_setValidAndNotEmptyArray:(nullable NSArray *)array forKey:(nonnull id)key {
    [self clue_setValidAndNotEmptyObject:array forKey:key];
}

- (void)clue_setValidAndNotEmptyObject:(nullable id)object forKey:(nonnull id)key {
    [self clue_setFilteredObject:object forKey:key withFilterBlock:^BOOL(id  _Nullable object) {
        if (object == nil) {
            return NO;
        }
        if ([object isKindOfClass:[NSString class]]) {
            return ((NSString *) object).length != 0;
        } else if ([object isKindOfClass:[NSDictionary class]]) {
            return ((NSDictionary *) object).count != 0;
        } else if ([object isKindOfClass:[NSArray class]]) {
            return ((NSArray *) object).count != 0;
        } else {
            return NO;
        }
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
