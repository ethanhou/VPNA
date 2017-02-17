//
//  NSMutableString+Ext.m
//  bolome_shared
//
//  Created by by on 3/13/15.
//  Copyright (c) 2015 bolome. All rights reserved.
//

#import "NSMutableString+Ext.h"

@implementation NSMutableString(Ext)

- (NSMutableString *)mutableXmlEncode
{
    [self replaceOccurrencesOfString:@"&"
                          withString:@"&amp;"
                             options:NSLiteralSearch
                               range:NSMakeRange(0, [self length])];
    [self replaceOccurrencesOfString:@"\""
                          withString:@"&quot;"
                             options:NSLiteralSearch
                               range:NSMakeRange(0, [self length])];
    [self replaceOccurrencesOfString:@"'"
                          withString:@"&#x27;"
                             options:NSLiteralSearch
                               range:NSMakeRange(0, [self length])];
    [self replaceOccurrencesOfString:@">"
                          withString:@"&gt;"
                             options:NSLiteralSearch
                               range:NSMakeRange(0, [self length])];
    [self replaceOccurrencesOfString:@"<"
                          withString:@"&lt;"
                             options:NSLiteralSearch
                               range:NSMakeRange(0, [self length])];
    
    return self;
}

- (NSMutableString *)mutableXmlDecode
{
    [self replaceOccurrencesOfString:@"&amp;"
                          withString:@"&"
                             options:NSLiteralSearch
                               range:NSMakeRange(0, [self length])];
    [self replaceOccurrencesOfString:@"&quot;"
                          withString:@"\""
                             options:NSLiteralSearch
                               range:NSMakeRange(0, [self length])];
    [self replaceOccurrencesOfString:@"&#x27;"
                          withString:@"'"
                             options:NSLiteralSearch
                               range:NSMakeRange(0, [self length])];
    [self replaceOccurrencesOfString:@"&#x39;"
                          withString:@"'"
                             options:NSLiteralSearch
                               range:NSMakeRange(0, [self length])];
    [self replaceOccurrencesOfString:@"&#x92;"
                          withString:@"'"
                             options:NSLiteralSearch
                               range:NSMakeRange(0, [self length])];
    [self replaceOccurrencesOfString:@"&#x96;"
                          withString:@"'"
                             options:NSLiteralSearch
                               range:NSMakeRange(0, [self length])];
    [self replaceOccurrencesOfString:@"&gt;"
                          withString:@">"
                             options:NSLiteralSearch
                               range:NSMakeRange(0, [self length])];
    [self replaceOccurrencesOfString:@"&lt;"
                          withString:@"<"
                             options:NSLiteralSearch
                               range:NSMakeRange(0, [self length])];
    
    return self;
}

@end
