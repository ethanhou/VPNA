//
//  NSMutableAttributedString+Ext.m
//  bolome_shared
//
//  Created by by on 3/20/15.
//  Copyright (c) 2015 bolome. All rights reserved.
//

#import "NSMutableAttributedString+Ext.h"
#import <CoreText/CoreText.h>

@implementation NSMutableAttributedString(Ext)

- (void) setFont:(UIFont *)font {
    [self setFont:font inRange:NSMakeRange(0, self.length)];
}

- (void) setFont:(UIFont *)font inRange:(NSRange)range {
    CTFontRef ctFont = CTFontCreateWithName((__bridge CFStringRef)font.fontName, font.pointSize, NULL);
    [self removeAttribute:(__bridge NSString *)kCTFontAttributeName range:range];
    [self addAttribute:(__bridge NSString *)kCTFontAttributeName value:(__bridge id)ctFont range:range];
    CFRelease(ctFont);
}

- (void) setColor:(UIColor *)color {
    [self setColor:color inRange:NSMakeRange(0, self.length)];
}

- (void) setColor:(UIColor *)color inRange:(NSRange)range {
    // set text color for CoreText
    [self removeAttribute:(__bridge NSString *)kCTForegroundColorAttributeName range:range];
    [self addAttribute:(__bridge NSString*)kCTForegroundColorAttributeName value:color range:range];
    
    // set text color for UIKit
    [self removeAttribute:NSForegroundColorAttributeName range:range];
    [self addAttribute:NSForegroundColorAttributeName value:color range:range];
}

- (void) setBackgroundColor:(UIColor *)color {
    [self setBackgroundColor:color inRange:NSMakeRange(0, self.length)];
}

- (void) setBackgroundColor:(UIColor *)color inRange:(NSRange)range {
    [self removeAttribute:NSBackgroundColorAttributeName range:range];
    [self addAttribute:NSBackgroundColorAttributeName value:color range:range];
}

- (void) setLineSpace:(CGFloat)space {
    [self setLineSpace:space lineHeightMultiple:1.0f];
}

- (void) setLineSpace:(CGFloat)space lineHeightMultiple:(CGFloat)multiple {
    [self setLineSpace:space lineHeightMultiple:multiple inRange:NSMakeRange(0, self.length)];
}

- (void) setLineSpace:(CGFloat)space lineHeightMultiple:(CGFloat)multiple inRange:(NSRange)range {
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    style.lineSpacing = space;
    style.lineHeightMultiple = multiple;
    
    [self setParagraphStyle:style inRange:range];    
}

- (void) setParagraphStyle:(NSMutableParagraphStyle *)style {
    [self setParagraphStyle:style inRange:NSMakeRange(0, self.length)];
}

- (void) setParagraphStyle:(NSMutableParagraphStyle *)style inRange:(NSRange)range {
    [self removeAttribute:(__bridge NSString *)kCTParagraphStyleAttributeName range:range];
    [self addAttribute:(__bridge NSString *)kCTParagraphStyleAttributeName value:style range:range];
}

- (void) setStrikethroughStyle:(NSUnderlineStyle)style {
    [self setStrikethroughStyle:style inRange:NSMakeRange(0, self.length)];
}

- (void) setStrikethroughStyle:(NSUnderlineStyle)style inRange:(NSRange)range {
    [self removeAttribute:NSStrikethroughStyleAttributeName range:range];
    [self addAttribute:NSStrikethroughStyleAttributeName value:@(style) range:range];
}

- (void) setUnderlineStyle:(NSUnderlineStyle)style {
    [self setUnderlineStyle:style inRange:NSMakeRange(0, self.length)];
}
- (void) setUnderlineStyle:(NSUnderlineStyle)style inRange:(NSRange)range {
    [self removeAttribute:NSUnderlineStyleAttributeName range:range];
    [self addAttribute:NSUnderlineStyleAttributeName value:@(style) range:range];
}

- (void) setAlignmentStyle:(NSTextAlignment)alignment {
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    style.alignment = alignment;
    
    [self setParagraphStyle:style];
}


@end
