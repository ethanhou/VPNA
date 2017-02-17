//
//  NSArray+Ext.h
//  bolome_shared
//
//  Created by by on 3/13/15.
//  Copyright (c) 2015 bolome. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray(Ext)

- (BOOL)isNotEmpty;

+ (BOOL)isNotEmptyArray:(id)array;

- (BOOL) isEqualToArray:(NSArray *)otherArray
           compareBlock:(BOOL(^)(id obj1, id obj2))compareBlock;

+ (BOOL) isIndex:(NSInteger)index inArray:(NSArray *)array;

- (id) objectAtIndexIfExist:(NSUInteger)index;

- (NSMutableArray*)zipWithGroupNum:(NSInteger)num;

- (NSMutableArray*)unzip;

+ (NSArray *) arrayWithObjectIfNotNil:(id)object;

@end
