//
//  NSMutableDictionary+CLUUtilsAdditions.h
//  Clue
//
//  Created by Ahmed Sulaiman on 4/21/17.
//  Copyright © 2017 Ahmed Sulaiman. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 `NSMutableDictionary (CLUUtilsAdditions)` category contains methods to simplify new object setting (with some specific conditions) into dictionary. We need this to safely parse invalid `UIView` properties for example (see `UIView (CLUViewRecordableAdditions)`).
 */
@interface NSMutableDictionary (CLUUtilsAdditions)

/**
 Set only valid (not nil) objects with key into current dictionary. If `object` is invalid – method will skip the object

 @param object Any object you want to add into dictionary. Could be invalid.
 @param key Any key for this new object. Should be valid.
 */
- (void)clue_setValidObject:(nullable id)object forKey:(nonnull id)key;

/**
 Set only objects which are confirms to some specific conditions in `filterBlock`. If `filterBlock` returns `NO` – method will skip the object
 
 @param object Any object you want to add into dictionary. Could be invalid.
 @param key Any key for this new object. Should be valid.
 @param filterBlock Block which will decide whether this object is valid for specific conditions or not and return BOOL. Based on this BOOL values method decide to put new object into dictionary or not
 */
- (void)clue_setFilteredObject:(nullable id)object
                        forKey:(nonnull id<NSCopying>)key
               withFilterBlock:(BOOL (^ _Nonnull)(id _Nullable object))filterBlock;

@end
