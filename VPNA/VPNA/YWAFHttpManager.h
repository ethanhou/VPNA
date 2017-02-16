//
//  YWAFHttpManager.h
//  AFN
//
//  Created by 龙章辉 on 15/5/14.
//  Copyright (c) 2015年 Peter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YWAFHttpResponse.h"
#import "AFNetworking.h"
#import "YWObject+Utils.h"
#import "YWAFHttpRequestCache.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>

extern NSString * const HTTPRetMsg_JSONError;
extern NSString * const HTTPRetMsg_Error;
extern NSString *const MicNetworkChangeNotification;

typedef void (^RequestOverBlock)(YWAFHttpResponse *response);
typedef enum {
    RequestTypeGet,
    RequestTypePost,
    
    
}RequestType;

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

typedef NS_ENUM(NSInteger,MicNetworkType){
    
    MicNetworkTypeUnknown,
    MicNetworkTypeNotReachable,
    MicNetworkTypeCellular,
    MicNetworkTypeWifi,
};

@interface YWAFHttpManager : NSObject

@property(nonatomic,getter=isReachable)BOOL reachable;
@property(nonatomic,getter=isWifi)BOOL wifi;
@property(nonatomic,getter=isCellular)BOOL cellular;
@property(nonatomic,assign)NSInteger networkType;
@property(nonatomic,strong)NSString *network;

/**
 * 移除网络监听
 */
- (void)removeMicNetWorkMonitor;

/**
 * 添加网络监听
 */
- (void)addMicNetworkMonitor;

+ (YWAFHttpManager *)shareHttpManager;

/**
 *  @Params fileParameters
 *  例子
 NSMutableArray *tmpPicArray = [NSMutableArray array];
 for (int i=0; i<picPathArray.count; i++)
 {
 NSString *key = [NSString stringWithFormat:@"pic%zi",i+1];
 AskImageModel *valueModel = [picPathArray objectAtIndex:i];
 NSString *value = valueModel.imagePath;
 [tmpPicArray addObject:@{key:value}];
 }
 */


/**
 *  post请求
 *
 */
- (void)requestPostURL:(NSString *)url
withParameters:(NSDictionary *)parameters
      withUserInfo:(NSDictionary *)userInfo
  withReqOverBlock:(RequestOverBlock)overBlock;


/**
 *  post 请求 （可传文件）
 *
 *  @param type           post方式 RequestTypeGet/RequestTypePost
 *  @param fileParameters post文件,具体参数上方注释例子
 */
- (void)requestURL:(NSString *)url
   withRequestType:(RequestType)type
    withParameters:(NSDictionary *)parameters
withFilesParameters:(NSArray *)fileParameters
      withUserInfo:(NSDictionary *)userInfo
  withReqOverBlock:(RequestOverBlock)overBlock;


/**
 *  post 请求 （可设置请求头）
 *
 *  @param httpHeaderParameters 请求头
 */
- (void)requestURL:(NSString *)url
   withRequestType:(RequestType)type
    withParameters:(NSDictionary *)parameters
withFilesParameters:(NSArray *)fileParameters
withHttpHeaderParameters:(NSDictionary *)httpHeaderParameters
      withUserInfo:(NSDictionary *)userInfo
  withReqOverBlock:(RequestOverBlock)overBlock;

/*
 canReqMany 是否可以连续请求
 */
- (void)requestURL:(NSString *)url
   withRequestType:(RequestType)type
    withParameters:(NSDictionary *)parameters
    withFilesParameters:(NSArray *)fileParameters
withHttpHeaderParameters:(NSDictionary *)httpHeaderParameters
    withTimeOutSeconds:(NSTimeInterval)timeoutSeconds
      withUserInfo:(NSDictionary *)userInfo
    withCanReqMany:(BOOL)canReqMany //是否结束了才能请求
    withReqOverBlock:(RequestOverBlock)overBlock;



- (void)uploadFileWithUrl:(NSString *)url
           withParameters:(NSDictionary *)parameters
      withFilesParameters:(NSArray *)fileParameters
        withProgressBlock:(void (^)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead))progress
         withReqOverBlock:(RequestOverBlock)overBlock;

/**
 *  文件下载
 *
 *  @param fileURL               要下载的url
 *  @param savePath              下载完成后的保存路径
 *  @param downloadProgressBlock 下载进度
 *  @param successBlock          下载完成回调
 *  @param errorBlock            下载失败回调
 */
- (void)downLoadFileWithUrl:(NSString *)fileURL
               fileSavePath:(NSString *)savePath
                   progress:(void (^)(NSProgress *downloadProgress)) downloadProgressBlock
                    success:(void (^)(NSURLResponse *response, NSURL *filePath))successBlock
                      error:(void (^)(NSError *error))errorBlock;

@end
