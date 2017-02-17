//
//  NSRegularExpression+Bolome.h
//  bolome_app
//
//  Created by by on 4/20/15.
//  Copyright (c) 2015 bolome. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DEFINE_REX(regName, expression) \
static inline NSRegularExpression *regName##Rex() { \
static NSRegularExpression *result = nil; \
static dispatch_once_t once; \
\
dispatch_once(&once, ^{ \
result = [[NSRegularExpression alloc] initWithPattern:(expression) \
options:NSRegularExpressionCaseInsensitive \
error:nil]; \
}); \
\
return result; \
}

@interface NSRegularExpression(Ext)

@end
