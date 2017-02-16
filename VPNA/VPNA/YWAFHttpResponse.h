//
//  YWAFHttpResponse.h
//  AFN
//
//  Created by 龙章辉 on 15/5/14.
//  Copyright (c) 2015年 Peter. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, HTTPRetCode) {
    HTTPRetCodeError=-10,
    HTTPRetCodeErrorJson=-11,
    HTTPRetCodeOK = 0,
    HTTPRetNotReponse = 2000,
};



@interface YWAFHttpResponse : NSObject


//result status
@property (nonatomic,assign) NSInteger ret;
//data
@property (nonatomic,strong) NSObject *data;
//result msg
@property (nonatomic,copy) NSString *msg;

//response
@property (nonatomic,strong) NSDictionary *responseDic;
//
@property (nonatomic,strong) NSDictionary *parameters;
//context
@property (nonatomic,strong) NSDictionary *userInfo;
//---- debug
@property (nonatomic,strong) NSData *responseData;
@property (nonatomic,strong) NSURL *requestURL;
@property (nonatomic,strong) NSString *ipAddress;
@property (nonatomic,strong) NSString *filePath;
@property (nonatomic,assign) CFTimeInterval requestTime;
@property (nonatomic,assign) NSInteger httpStatusCode;
@end
