//
//  NSMutableArray+Ext.h
//  bolome_shared
//
//  Created by by on 3/13/15.
//  Copyright (c) 2015 bolome. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray(Ext)

/*
 * Create a mutable array that do not retain its' items
 */
+ (instancetype)noneRetainItemArray;
- (void)addObjectIfNotNil:(id)anObject;

@end
