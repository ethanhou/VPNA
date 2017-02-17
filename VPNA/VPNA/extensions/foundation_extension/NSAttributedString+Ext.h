//
//  NSAttributedString+Ext.h
//  bolome_shared
//
//  Created by by on 4/20/15.
//  Copyright (c) 2015 bolome. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSAttributedString(Ext)

+ (instancetype) string:(NSString *)string;
+ (instancetype) string:(NSString *)string
                  block:(void (^)(NSMutableAttributedString *mString, NSString *string)) block;

+ (instancetype) string:(NSString *)string
                  color:(UIColor *)color;
+ (instancetype) string:(NSString *)string
                  color:(UIColor *)color
                  block:(void (^)(NSMutableAttributedString *mString, NSString *string)) block;

+ (instancetype) string:(NSString *)string
                   font:(UIFont*)font;
+ (instancetype) string:(NSString *)string
                   font:(UIFont*)font
                  block:(void (^)(NSMutableAttributedString *mString, NSString *string)) block;

+ (instancetype) string:(NSString *)string
                  color:(UIColor *)color
                   font:(UIFont*)font;
+ (instancetype) string:(NSString *)string
                  color:(UIColor *)color
                   font:(UIFont*)font
                  block:(void (^)(NSMutableAttributedString *mString, NSString *string)) block;

// default encoding UTF-8
+ (instancetype) htmlString:(NSString *)htmlString
                       font:(UIFont *)font;
+ (instancetype) htmlString:(NSString *)htmlString
                   encoding:(NSStringEncoding)encoding
                       font:(UIFont *)font;
+ (instancetype) htmlString:(NSString *)htmlString
                   encoding:(NSStringEncoding)encoding
                       font:(UIFont *)font
                      block:(void (^)(NSMutableAttributedString *mString, NSString *string)) block;

+ (instancetype) mergeAttributedStrings:(NSArray *)strings;
+ (instancetype) mergeAttributedStrings:(NSArray *)strings
                                  block:(void (^)(NSMutableAttributedString *mString))block;

@end
