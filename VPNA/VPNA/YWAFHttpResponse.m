//
//  YWHttpResponse.m
//  AFN
//
//  Created by 龙章辉 on 15/5/14.
//  Copyright (c) 2015年 Peter. All rights reserved.
//

#import "YWAFHttpResponse.h"

@implementation YWAFHttpResponse
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.data = [NSMutableDictionary dictionary];
        self.responseDic = @{};

    }
    return self;
}

- (NSString *)description
{
    NSData *data = [NSJSONSerialization dataWithJSONObject:self.responseDic options:NSJSONWritingPrettyPrinted error:nil];
    NSString *dataS = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return [NSString stringWithFormat:@"time %f code %zi url %@ ip %@ ret:%zi \n msg:%@ \n response: %@ ",self.requestTime,self.httpStatusCode,self.requestURL,self.ipAddress, self.ret,self.msg,dataS];
}
@end
