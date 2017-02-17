//
//  NSThread+Ext.m
//  bolome_shared
//
//  Created by by on 7/17/15.
//  Copyright (c) 2015 bolome. All rights reserved.
//

#import "NSThread+Ext.h"
#import "NSObject+Ext.h"

#define CustomizedRunloopMode @"CustomizedRunloopMode"

@interface NSThread(Ext_private)

@property (atomic, assign) BOOL pausing;

@end

#pragma mark -

@implementation NSThread(Ext_private)

@dynamic pausing;
- (BOOL) pausing {
    NSNumber *num = GET_ASSOCIATED_OBJ();
    return num.boolValue;
}
- (void) setPausing:(BOOL)b {
    NSNumber *pausing = @(b);
    SET_ASSOCIATED_OBJ_RETAIN_NONATOMIC(pausing);
}

@end

#pragma mark -

@implementation NSThread(Ext)

- (void) pause {
    self.pausing = YES;
    
    while (self.pausing) {
        NSRunLoop *runLoop = NSRunLoop.currentRunLoop;

        // add CustomizedRunloopMode into commonModes, so that dispatch_async can run block in this run loop, otherwise not
        // check this out: http://lapcatsoftware.com/articles/dispatch-queues-and-run-loop-modes.html
        CFRunLoopAddCommonMode([runLoop getCFRunLoop], (__bridge CFStringRef)CustomizedRunloopMode);

        [runLoop runMode:CustomizedRunloopMode beforeDate:[NSDate distantFuture]];
    }
}

- (void) _internalContinue {
    self.pausing = NO;
}

- (void) continue {
    // cause runloop to process the method and return from runMode:beforeDate:
    [self performSelector:@selector(_internalContinue)
                 onThread:NSThread.currentThread
               withObject:nil
            waitUntilDone:NO
                    modes:@[CustomizedRunloopMode]];
}

@end
