//
//  NSMutableAttributedString+Ext.h
//  bolome_shared
//
//  Created by by on 3/20/15.
//  Copyright (c) 2015 bolome. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSMutableAttributedString(Ext)

- (void) setFont:(UIFont *)font;
- (void) setFont:(UIFont *)font inRange:(NSRange)range;

- (void) setColor:(UIColor *)color;
- (void) setColor:(UIColor *)color inRange:(NSRange)range;

- (void) setBackgroundColor:(UIColor *)color;
- (void) setBackgroundColor:(UIColor *)color inRange:(NSRange)range;

- (void) setLineSpace:(CGFloat)space;
- (void) setLineSpace:(CGFloat)space lineHeightMultiple:(CGFloat)multiple;
- (void) setLineSpace:(CGFloat)space lineHeightMultiple:(CGFloat)multiple inRange:(NSRange)range;

- (void) setParagraphStyle:(NSMutableParagraphStyle *)style;
- (void) setParagraphStyle:(NSMutableParagraphStyle *)style inRange:(NSRange)range;

- (void) setStrikethroughStyle:(NSUnderlineStyle)style;
- (void) setStrikethroughStyle:(NSUnderlineStyle)style inRange:(NSRange)range;

- (void) setUnderlineStyle:(NSUnderlineStyle)style;
- (void) setUnderlineStyle:(NSUnderlineStyle)style inRange:(NSRange)range;

- (void) setAlignmentStyle:(NSTextAlignment)alignment;

@end
