//
//  NSArray+Ext.m
//  bolome_shared
//
//  Created by by on 3/13/15.
//  Copyright (c) 2015 bolome. All rights reserved.
//

#import "NSArray+Ext.h"

@implementation NSArray(Ext)

- (BOOL)isNotEmpty {
    return [self isKindOfClass:[NSArray class]] && [self count] > 0;
}

+ (BOOL)isNotEmptyArray:(id)array {
    return (array != nil && [array isKindOfClass:[NSArray class]] && [array count] > 0);
}

- (BOOL) isEqualToArray:(NSArray *)otherArray
           compareBlock:(BOOL(^)(id obj1, id obj2))compareBlock {
    if (otherArray == self) {
        return YES;
    }
    
    if (otherArray.count != self.count) {
        return NO;
    }
    
    __block BOOL result = YES;
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (!compareBlock(obj, otherArray[idx])) {
            result = NO;
            *stop = YES;
        }
    }];
    
    return result;
}

+ (BOOL) isIndex:(NSInteger)index inArray:(NSArray *)array {
    return (array && array.count) ? (index >= 0 && index < array.count) : NO;
}

- (id) objectAtIndexIfExist:(NSUInteger)index {
    return [NSArray isIndex:index inArray:self] ? self[index] : nil;
}

- (NSMutableArray*)zipWithGroupNum:(NSInteger)num
{
    NSMutableArray *dealedAry = [NSMutableArray array];
    NSInteger lines = 0;
    float originCount = [self count];
    float value = originCount/num;
    lines = ceilf(value);
    
    //每组多少个
    NSRange range;
    range.location = 0;
    range.length = num;
    
    NSArray *groupArray = nil;
    
    for (int i = 0; i<lines; i++) {
        if (originCount < range.location + range.length)
        {
            range.length = originCount - range.location; //最后一组
        }
        groupArray = [self subarrayWithRange:range]; //第i行的数据
        if (groupArray.count<1) {
            //lines越界
            continue;
        }
        [dealedAry addObject:groupArray];
        
        range.location += range.length;
    }
    return dealedAry;
}

- (NSMutableArray*)unzip
{
    NSMutableArray *dealedAry = [NSMutableArray array];
    for (NSArray *ary in self) {
        [dealedAry addObjectsFromArray:ary];
    }
    return dealedAry;
}

+ (NSArray *) arrayWithObjectIfNotNil:(id)object {
    return object ? @[object] : nil;
}


@end
