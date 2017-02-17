//
//  NSMutableArray+Ext.m
//  bolome_shared
//
//  Created by by on 3/13/15.
//  Copyright (c) 2015 bolome. All rights reserved.
//

#import "NSMutableArray+Ext.h"

static const void* _retainNoOp(CFAllocatorRef allocator, const void *value) { return value; }
static void _releaseNoOp(CFAllocatorRef allocator, const void *value) { }

@implementation NSMutableArray(Ext)

+ (instancetype)noneRetainItemArray {
    CFArrayCallBacks callbacks = kCFTypeArrayCallBacks;
    callbacks.retain = _retainNoOp;
    callbacks.release = _releaseNoOp;
    return (NSMutableArray*)CFBridgingRelease(CFArrayCreateMutable(nil, 0, &callbacks));
}

- (void)addObjectIfNotNil:(id)anObject {
    if (anObject!=nil) {
        [self addObject:anObject];
    }
}

@end
