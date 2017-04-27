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
 Set only valid (not nil) and not empty string with key into current dictionary. If `string` is invalid or empty – method will skip this `string`

 @param string Any string you want to add into current dictionary. Could be invalid or empty
 @param key Any key for this new string. Should be valid.
 */
- (void)clue_setValidAndNotEmptyString:(nullable NSString *)string forKey:(nonnull id)key;

/**
 Set only valid (not nil) and not empty dictionary with key into current dictionary. If `dictionary` is invalid or empty – method will skip this `dictionary`

 @param dictionary Any dictionary you want to add into current dictionary. Could be invalid or empty
 @param key Any key for this new dictionary. Should be valid.
 */
- (void)clue_setValidAndNotEmptyDictionary:(nullable NSDictionary *)dictionary forKey:(nonnull id)key;

/**
 Set only valid (not nil) and not empty array with key into current dictionary. If `array` is invalid or empty – method will skip this `array`

 @param array Any array you want to add into current dictionary. Could be invalid or empty
 @param key Any key for this new dictionary. Should be valid.
 */
- (void)clue_setValidAndNotEmptyArray:(nullable NSArray *)array forKey:(nonnull id)key;

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
