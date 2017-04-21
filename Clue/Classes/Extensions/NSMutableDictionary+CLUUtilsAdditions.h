//
//  NSMutableDictionary+CLUUtilsAdditions.h
//  Clue
//
//  Created by Ahmed Sulaiman on 4/21/17.
//  Copyright © 2017 Ahmed Sulaiman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (CLUUtilsAdditions)

- (void)clue_setValidObject:(nullable id)object forKey:(nonnull id)key;

- (void)clue_setFilteredObject:(nullable id)object
                        forKey:(nonnull id<NSCopying>)key
               withFilterBlock:(BOOL (^ _Nonnull)(id _Nullable object))filterBlock;

@end
