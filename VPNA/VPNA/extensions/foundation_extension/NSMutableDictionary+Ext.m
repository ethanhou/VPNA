//
//  NSMutableDictionary+Ext.m
//  bolome_shared
//
//  Created by by on 3/13/15.
//  Copyright (c) 2015 bolome. All rights reserved.
//

#import "NSMutableDictionary+Ext.h"

static const void* _retainNoOp(CFAllocatorRef allocator, const void *value) { return value; }
static void _releaseNoOp(CFAllocatorRef allocator, const void *value) { }

@implementation NSMutableDictionary(Ext)

+ (instancetype)noneRetainKeyDict {
    CFDictionaryKeyCallBacks keyCallBacks = kCFTypeDictionaryKeyCallBacks;
    CFDictionaryValueCallBacks valueCallBacks = kCFTypeDictionaryValueCallBacks;
    keyCallBacks.retain = _retainNoOp;
    keyCallBacks.release = _releaseNoOp;
    return (NSMutableDictionary*)CFBridgingRelease(CFDictionaryCreateMutable(nil, 0, &keyCallBacks, &valueCallBacks));
}

/*
 * Create a mutable dictionary that do not retain value, but retain key
 */
+ (instancetype)noneRetainValueDict {
    CFDictionaryKeyCallBacks keyCallBacks = kCFTypeDictionaryKeyCallBacks;
    CFDictionaryValueCallBacks valueCallBacks = kCFTypeDictionaryValueCallBacks;
    valueCallBacks.retain = _retainNoOp;
    valueCallBacks.release = _releaseNoOp;
    return (NSMutableDictionary*)CFBridgingRelease(CFDictionaryCreateMutable(nil, 0, &keyCallBacks, &valueCallBacks));

}

/*
 * Create a mutable dictionary that do not retain both key and value
 */
+ (instancetype)noneRetainKeyValueDict {
    CFDictionaryKeyCallBacks keyCallBacks = kCFTypeDictionaryKeyCallBacks;
    CFDictionaryValueCallBacks valueCallBacks = kCFTypeDictionaryValueCallBacks;
    keyCallBacks.retain = _retainNoOp;
    keyCallBacks.release = _releaseNoOp;
    valueCallBacks.retain = _retainNoOp;
    valueCallBacks.release = _releaseNoOp;
    return (NSMutableDictionary*)CFBridgingRelease(CFDictionaryCreateMutable(nil, 0, &keyCallBacks, &valueCallBacks));
}

- (NSMutableDictionary *)mutableDeepCopy
{
    NSMutableDictionary *ret=[NSMutableDictionary dictionaryWithCapacity:[self count] ]; //new construct NSMutableDictionary
    NSArray *keys=[self allKeys];
    
    for (id key in keys) {
        id oneValue=[self objectForKey:key]; //old NSObject
        id oneCopy=nil; //new NSObject
        if ([oneValue isKindOfClass:[NSNumber class]]) {
            oneCopy=[oneValue copy];
        }
        else if ([oneValue respondsToSelector:@selector(mutableDeepCopy)]){
             oneCopy=[oneValue mutableDeepCopy];
        }
        else if ([oneValue respondsToSelector:@selector(mutableCopy)]){
            oneCopy=[oneValue mutableCopy];
        }
        
        if (oneCopy==nil)
        {
            oneCopy=[oneValue copy];
        }
        [ret setValue:oneCopy forKey:key];
    }//end for
    return ret;
}

@end
