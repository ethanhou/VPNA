//
//  NSMutableDictionary+Ext.h
//  bolome_shared
//
//  Created by by on 3/13/15.
//  Copyright (c) 2015 bolome. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary(Ext)

/*
 * Create a mutable dictionary that do not retain key, but retain value
 */
+ (instancetype)noneRetainKeyDict;

/*
 * Create a mutable dictionary that do not retain value, but retain key
 */
+ (instancetype)noneRetainValueDict;

/*
 * Create a mutable dictionary that do not retain both key and value
 */
+ (instancetype)noneRetainKeyValueDict;

- (NSMutableDictionary *)mutableDeepCopy;

@end
