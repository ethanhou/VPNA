//
//  NSAttributedString+Ext.m
//  bolome_shared
//
//  Created by by on 4/20/15.
//  Copyright (c) 2015 bolome. All rights reserved.
//

#import "NSAttributedString+Ext.h"
#import "NSMutableAttributedString+Ext.h"

@implementation NSAttributedString(Ext)

+ (instancetype) string:(NSString *)string {
    return [self string:string color:nil font:nil block:nil];
}

+ (instancetype) string:(NSString *)string
                  block:(void (^)(NSMutableAttributedString *mString, NSString *string)) block {
    return [self string:string color:nil font:nil block:block];
}

+ (instancetype) string:(NSString *)string
                  color:(UIColor *)color {
    return [self string:string color:color font:nil block:nil];
}

+ (instancetype) string:(NSString *)string
                  color:(UIColor *)color
                  block:(void (^)(NSMutableAttributedString *mString, NSString *string)) block {
    return [self string:string color:color font:nil block:block];
}

+ (instancetype) string:(NSString *)string
                   font:(UIFont*)font {
    return [self string:string color:nil font:font block:nil];
}

+ (instancetype) string:(NSString *)string
                   font:(UIFont*)font
                  block:(void (^)(NSMutableAttributedString *mString, NSString *string)) block {
    return [self string:string color:nil font:font block:block];
}

+ (instancetype) string:(NSString *)string
                  color:(UIColor *)color
                   font:(UIFont*)font {
    return [self string:string color:color font:font block:nil];
}

+ (instancetype) string:(NSString *)string
                  color:(UIColor *) color
                   font:(UIFont*) font
                  block:(void (^)(NSMutableAttributedString *mString, NSString *string)) block {
    if (!string) {
        return nil;
    }
    
    NSMutableAttributedString *result = [[NSMutableAttributedString alloc] initWithString:string attributes:nil];
    
    NSRange range = NSMakeRange(0, string.length);
    if (color) {
        [result setColor:color inRange:range];
    }
    
    if (font) {
        [result setFont:font inRange:range];
    }
    
    if (block) {
        block(result, string);
    }
    
    return result;
}

+ (instancetype) htmlString:(NSString *)htmlString
                       font:(UIFont *)font {
    return [self htmlString:htmlString
                   encoding:NSUTF8StringEncoding
                       font:font];
}

+ (instancetype) htmlString:(NSString *)htmlString
                   encoding:(NSStringEncoding)encoding
                       font:(UIFont *)font {
    return [self htmlString:htmlString
                   encoding:encoding
                       font:font
                      block:nil];
}

+ (instancetype) htmlString:(NSString *)htmlString
                   encoding:(NSStringEncoding)encoding
                       font:(UIFont *)font
                      block:(void (^)(NSMutableAttributedString *mString, NSString *string)) block {
    //http://stackoverflow.com/questions/28915954/nsattributedstring-initwithdata-and-nshtmltextdocumenttype-crash-if-not-on-main
    //为了防止在非主线程使用该方法，特加上此断言
    NSAssert([NSThread isMainThread], @"This action must be called on main thread");
    
    NSData *data = [htmlString dataUsingEncoding:encoding];

    NSMutableAttributedString *result = \
    [[NSMutableAttributedString alloc] initWithData:data
                                            options:@{
                                                    NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                                                    NSCharacterEncodingDocumentAttribute: @(encoding)
                                            }
                                 documentAttributes:nil
                                              error:nil];

    if (font) {
        NSRange range = NSMakeRange(0, result.length);
        [result setFont:font inRange:range];
    }

    if (block) {
        block(result, htmlString);
    }

    return result;
}

+ (instancetype) mergeAttributedStrings:(NSArray *)strings {
    return [self mergeAttributedStrings:strings
                                  block:nil];
}

+ (instancetype) mergeAttributedStrings:(NSArray *)strings
                                  block:(void (^)(NSMutableAttributedString *mString))block {
    NSMutableAttributedString *result = [NSMutableAttributedString new];
    
    [strings enumerateObjectsUsingBlock:^(NSAttributedString *string, NSUInteger idx, BOOL *stop) {
        [result appendAttributedString:string];
    }];
    
    if (block) {
        block(result);
    }
    
    return result;
}

@end
