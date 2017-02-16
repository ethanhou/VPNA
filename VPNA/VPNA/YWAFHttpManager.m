//
//  YWHttpManager.m
//  AFN
//
//  Created by 龙章辉 on 15/5/14.
//  Copyright (c) 2015年 Peter. All rights reserved.
//

#import "YWAFHttpManager.h"
#import <CommonCrypto/CommonDigest.h>
#import "AFHTTPRequestOperationManager.h"

#include <netdb.h>
#include <arpa/inet.h>
NSString * const HTTPRetMsg_JSONError = @"服务器偷懒了";
NSString * const HTTPRetMsg_Error = @"网络生病了...";
NSString *const MicNetworkChangeNotification = @"MicNetworkChangeNotification";


NSString *MD5(NSString *handleString);
NSString *MD5(NSString *handleString)
{
    const char *cStr = [handleString UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}



#define MaxReqQueueCount 3

#define MaxRequestTimeOut 30

@interface YWAFHttpManager()
@property (nonatomic,strong) NSMutableDictionary *requestCache;
//@property (nonatomic,strong) AFHTTPSessionManager *sessionManager;
@property (nonatomic,strong) AFHTTPRequestOperationManager *operationManager;
@end

@implementation YWAFHttpManager

- (NSString*)getIPAddressByHostName:(NSString*)strHostName
{
    if (strHostName==nil || strHostName.length == 0) {
        return @"";
    }
    
    if (![AFNetworkReachabilityManager sharedManager].reachable) {
        return @"";
    }
NSLog(@"strHostName %@",strHostName);
    NSString *localURL = [strHostName stringByReplacingOccurrencesOfString:@"http://" withString:@""];
    localURL = [localURL stringByReplacingOccurrencesOfString:@"https://" withString:@""];
    NSArray *array = [localURL componentsSeparatedByString:@"/"];
//    NSString *host = nil;
    if (array && array.count >0) {
        strHostName = array[0];
        
        NSArray *a = [strHostName componentsSeparatedByString:@":"];
        if (a && a.count >0) {
            strHostName = a[0];
        }
    }
    
    NSLog(@"strHostName %@",strHostName);
    
    
   
    const char* szname = [strHostName UTF8String];
    struct hostent* phot ;
    @try
    {
        phot = gethostbyname(szname);
    }
    @catch (NSException * e)
    {
        return nil;
    }
    
    struct in_addr ip_addr;
    memcpy(&ip_addr,phot->h_addr_list[0],4);
    ///h_addr_list[0]里4个字节,每个字节8位，此处为一个数组，一个域名对应多个ip地址或者本地时一个机器有多个网卡
    
    char ip[20] = {0};
    inet_ntop(AF_INET, &ip_addr, ip, sizeof(ip));
    
    NSString* strIPAddress = [NSString stringWithUTF8String:ip];
    
    return strIPAddress;
}

+ (YWAFHttpManager *)shareHttpManager
{
    static YWAFHttpManager *sharedInstance = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[YWAFHttpManager alloc] init];
        
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.requestCache = [NSMutableDictionary dictionary];
        
//        if (IOS6_7) {
          self.operationManager = [AFHTTPRequestOperationManager manager];
        self.operationManager.operationQueue.maxConcurrentOperationCount = MaxReqQueueCount;
//        }else{
//            self.sessionManager = [AFHTTPSessionManager manager];
//            self.sessionManager.operationQueue.maxConcurrentOperationCount = MaxReqQueueCount;
//        }
    }
    return self;
}

- (NSString *)processRequestKey:(NSString *)url
                withRequestType:(RequestType)type
                withParameters:(NSDictionary *)parameters
                withFilesParameters:(NSArray *)fileParameters{
    NSString *p = @"";
    if (parameters) {
        p = [parameters jsonString];
    }
    NSString *f = @"";
    if (fileParameters) {
        f = [fileParameters jsonString];
    }
    
    NSString *requestKey = [NSString stringWithFormat:@"%@%d%@%@",url,type,p,f];
    return MD5(requestKey);

}
- (YWAFHttpResponse *)processRequestOverData:(NSData *)responseData
{
    YWAFHttpResponse *response = [[YWAFHttpResponse alloc] init];
    response.data = responseData;
    NSError *error = nil;
    NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
    if (error != nil || responseObject == nil || ![responseObject isKindOfClass:[NSDictionary class]]) {
        response.ret = HTTPRetCodeErrorJson;
        response.msg = HTTPRetMsg_JSONError;

        NSLog(@"request Error : %@ %@",HTTPRetMsg_JSONError,[error description]);
        return response;
    }
    
    NSNumber *ret = NumberValue(responseObject[@"ret"]);
    NSString *msg = StringValue(responseObject[@"msg"]);
    NSObject *data = responseObject[@"data"];

    response.ret = [ret integerValue];
    response.msg = msg;
    response.data = data;
    response.responseDic = responseObject;
    return response;
}
- (YWAFHttpResponse *)processRequestError:(NSError *)error
{
    
    YWAFHttpResponse *response = [[YWAFHttpResponse alloc] init];
    response.ret = HTTPRetCodeError;
    response.msg = HTTPRetMsg_Error;
    NSLog(@"request Error : %@ %@",HTTPRetMsg_Error,[error description]);
    return response;
}
- (void)printResponse:(AFHTTPRequestOperation *)requestOperation
{
    NSData *responseData =requestOperation.responseData;
    NSURL *url  = requestOperation.request.URL;
    NSString *string = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    
    NSError *error = nil;
    NSDictionary *object = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&error];
    NSString *responseString = @"json error";
    if (error == nil && [object isKindOfClass:[NSDictionary class]]) {
       NSData *data = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&error];
        responseString= [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
    }
    
    
    
    NSLog(@"\n ---xxxx-----response----xxxx-----:"
                 "\n URL %@"
                 "\n responseString:\n %@\n  prittyPrinted\n %@",url,string,responseString);

}




- (void)print_error:(NSError *)error withURL:(NSURL *)url{
    [self print_error:error withURL:url withHttpStauts:-1] ;
}
- (void)print_error:(NSError *)error withURL:(NSURL *)url withHttpStauts:(NSInteger)status
{
    NSLog(@"\n ---xxxx-----response----xxxx-----:"
                 "\n URL %@"
                 "\n status %d"
                 "\n error:%@",url,(int)status,error.description);
}


- (void)requestPostURL:(NSString *)url
    withParameters:(NSDictionary *)parameters
      withUserInfo:(NSDictionary *)userInfo
  withReqOverBlock:(RequestOverBlock)overBlock
{
    return [self requestURL:url
            withRequestType:RequestTypePost
             withParameters:parameters
        withFilesParameters:nil
               withUserInfo:userInfo
           withReqOverBlock:overBlock];
}
- (void)requestURL:(NSString *)url
   withRequestType:(RequestType)type
    withParameters:(NSDictionary *)parameters
withFilesParameters:(NSArray *)fileParameters
      withUserInfo:(NSDictionary *)userInfo
  withReqOverBlock:(RequestOverBlock)overBlock
{
    [self requestURL:url
     withRequestType:type
      withParameters:parameters
 withFilesParameters:fileParameters
     withHttpHeaderParameters:nil
  withTimeOutSeconds:MaxRequestTimeOut
        withUserInfo:userInfo
      withCanReqMany:YES
    withReqOverBlock:overBlock];
}
- (void)requestURL:(NSString *)url
   withRequestType:(RequestType)type
    withParameters:(NSDictionary *)parameters
withFilesParameters:(NSArray *)fileParameters
withHttpHeaderParameters:(NSDictionary *)httpHeaderParameters
      withUserInfo:(NSDictionary *)userInfo
  withReqOverBlock:(RequestOverBlock)overBlock
{
    [self requestURL:url
     withRequestType:type
      withParameters:parameters
 withFilesParameters:fileParameters
     withHttpHeaderParameters:httpHeaderParameters
  withTimeOutSeconds:MaxRequestTimeOut
        withUserInfo:userInfo
      withCanReqMany:YES
    withReqOverBlock:overBlock];
}

- (void)requestURL:(NSString *)url
   withRequestType:(RequestType)type
    withParameters:(NSDictionary *)parameters
withFilesParameters:(NSArray *)fileParameters
withHttpHeaderParameters:(NSDictionary *)httpHeaderParameters
withTimeOutSeconds:(NSTimeInterval)timeoutSeconds
      withUserInfo:(NSDictionary *)userInfo
  withCanReqMany:(BOOL)canReqMany
  withReqOverBlock:(RequestOverBlock)overBlock
{
    if (!canReqMany) {
        NSString *requestKey = [self processRequestKey:url withRequestType:type withParameters:parameters withFilesParameters:fileParameters];
        NSString *requestSt = self.requestCache[requestKey];
        if (requestSt) {
            return;
        }
        self.requestCache[requestKey] = requestKey;
    }
    
        [self requestIOS6_7URL:url
               withRequestType:type
                withParameters:parameters
           withFilesParameters:fileParameters
         withHttpHeaderParameters:httpHeaderParameters
            withTimeOutSeconds:timeoutSeconds
                  withUserInfo:userInfo
                withCanReqMany:canReqMany withReqOverBlock:overBlock];

}
- (void)requestIOS6_7URL:(NSString *)url
   withRequestType:(RequestType)type
    withParameters:(NSDictionary *)parameters
withFilesParameters:(NSArray *)fileParameters
withHttpHeaderParameters:(NSDictionary *)httpHeaderParameters
withTimeOutSeconds:(NSTimeInterval)timeoutSeconds
      withUserInfo:(NSDictionary *)userInfo
  withCanReqMany:(BOOL)canReqMany
        withReqOverBlock:(RequestOverBlock)overBlock{
    
    NSLog(@"parameters %@ fileParameters %@ userInfo %@",parameters,fileParameters,userInfo);
    
   CFTimeInterval now = CACurrentMediaTime();
    NSString *requestKey = [self processRequestKey:url withRequestType:type withParameters:parameters withFilesParameters:fileParameters];

    AFHTTPRequestSerializer *requestSerializer =[AFHTTPRequestSerializer serializer];
    requestSerializer.timeoutInterval = MaxRequestTimeOut;
    requestSerializer.stringEncoding = NSUTF8StringEncoding;
    //设置请求头
    NSArray *headers = httpHeaderParameters.allKeys;
    [headers enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop) {
        
        NSString *value = [NSString stringWithFormat:@"%@",[httpHeaderParameters objectForKey:key]];
        [requestSerializer setValue:value forHTTPHeaderField:key];
    }];
    
    AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
    responseSerializer.stringEncoding = NSUTF8StringEncoding;
    
    self.operationManager.requestSerializer = requestSerializer;
    self.operationManager.responseSerializer =responseSerializer;
    if (type == RequestTypeGet) {
        
            [self.operationManager GET:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            if (!canReqMany) {
                [self.requestCache removeObjectForKey:requestKey];
            }
            [self printResponse:operation];
          YWAFHttpResponse *response = [self processRequestOverData:responseObject];
            response.parameters = parameters;
            response.httpStatusCode = operation.response.statusCode;
            response.requestTime = CACurrentMediaTime() - now;
            response.requestURL = operation.request.URL;
            response.responseData = operation.responseData;
            response.userInfo = userInfo;
            if (response.httpStatusCode >0) {
            response.ipAddress = [self getIPAddressByHostName:operation.request.URL.absoluteString];
            }
            if(overBlock){
                overBlock(response);
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

            if (!canReqMany) {
                [self.requestCache removeObjectForKey:requestKey];
            }
            [self print_error:error withURL:operation.request.URL withHttpStauts:operation.response.statusCode];
            YWAFHttpResponse *response = [self processRequestError:error];
            response.parameters = parameters;
            response.requestTime = CACurrentMediaTime() - now;
            response.requestURL = operation.request.URL;
            response.httpStatusCode = operation.response.statusCode;
            response.responseData = operation.responseData;
            response.userInfo = userInfo;
            if (response.httpStatusCode >0) {
                response.ipAddress = [self getIPAddressByHostName:operation.request.URL.absoluteString];
            }
            if(overBlock){
                overBlock(response);
            }
        }];
        
    }else if (type == RequestTypePost) {
        if (fileParameters == nil) {
            [self.operationManager POST:url parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {

                if (!canReqMany) {
                    [self.requestCache removeObjectForKey:requestKey];
                }
                [self printResponse:operation];
                YWAFHttpResponse *response = [self processRequestOverData:responseObject];
                response.parameters = parameters;
                response.httpStatusCode = operation.response.statusCode;
                response.requestTime = CACurrentMediaTime() - now;
                response.requestURL = operation.request.URL;
                response.responseData = operation.responseData;
                response.userInfo = userInfo;
                if (response.httpStatusCode >0) {
                    response.ipAddress = [self getIPAddressByHostName:operation.request.URL.absoluteString];
                }
                
                if(overBlock){
                    overBlock(response);
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

                if (!canReqMany) {
                    [self.requestCache removeObjectForKey:requestKey];
                }
               [self print_error:error withURL:operation.request.URL  withHttpStauts:operation.response.statusCode];
                YWAFHttpResponse *response = [self processRequestError:error];
                response.parameters = parameters;
                response.requestTime = CACurrentMediaTime() - now;
                response.httpStatusCode = operation.response.statusCode;
                response.requestURL = operation.request.URL;
                response.responseData = operation.responseData;
                response.userInfo = userInfo;
                if (response.httpStatusCode >0) {
                    response.ipAddress = [self getIPAddressByHostName:operation.request.URL.absoluteString];
                }
                if(overBlock){
                    overBlock(response);
                }
            }];
        }else{
            [self.operationManager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                
                for (int i=0; i<fileParameters.count; i++)
                {
                    NSDictionary *pathDic = DictionaryValue([fileParameters objectAtIndex:i]);
                    NSArray *allKeys = pathDic.allKeys;
                    NSString *pathKey = [allKeys firstObject];
                    NSString *path = pathDic[pathKey];
                    NSError *err;
                    [formData appendPartWithFileURL:[NSURL fileURLWithPath:path] name:pathKey error:&err];
                    if (err) {
                        NSLog(@"upload file error %@",[err description]);
                    }
                }

                
            } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                if (!canReqMany) {
                    [self.requestCache removeObjectForKey:requestKey];
                }
                [self printResponse:operation];
                YWAFHttpResponse *response = [self processRequestOverData:responseObject];
                response.parameters = parameters;
                response.userInfo = userInfo;
                response.requestTime = CACurrentMediaTime() - now;
                response.httpStatusCode = operation.response.statusCode;
                response.requestURL = operation.request.URL;
                response.responseData = operation.responseData;
                if (response.httpStatusCode >0) {
                    response.ipAddress = [self getIPAddressByHostName:operation.request.URL.absoluteString];
                }
                if(overBlock){
                    overBlock(response);
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (!canReqMany) {
                    [self.requestCache removeObjectForKey:requestKey];
                }
                [self print_error:error withURL:operation.request.URL  withHttpStauts:operation.response.statusCode];
                YWAFHttpResponse *response = [self processRequestError:error];
                response.parameters = parameters;
                response.requestTime = CACurrentMediaTime() - now;
                response.httpStatusCode = operation.response.statusCode;
                response.requestURL = operation.request.URL;
                response.responseData = operation.responseData;
                response.userInfo = userInfo;
                if (response.httpStatusCode >0) {
                    response.ipAddress = [self getIPAddressByHostName:operation.request.URL.absoluteString];
                }
                if(overBlock){
                    overBlock(response);
                }
            }];
        }
       
    }

}


- (void)uploadFileWithUrl:(NSString *)url
           withParameters:(NSDictionary *)parameters
      withFilesParameters:(NSArray *)fileParameters
        withProgressBlock:(void (^)(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead))progress
         withReqOverBlock:(RequestOverBlock)overBlock

{
    CFTimeInterval now = CACurrentMediaTime();
    NSMutableURLRequest *request  = [self.operationManager.requestSerializer
                                     multipartFormRequestWithMethod:@"POST"
                                     URLString:url
                                     parameters:parameters
                                     constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                                         
                                         
                                         for (int i=0; i<fileParameters.count; i++)
                                         {
                                             NSDictionary *pathDic = DictionaryValue([fileParameters objectAtIndex:i]);
                                             NSArray *allKeys = pathDic.allKeys;
                                             NSString *pathKey = [allKeys firstObject];
                                             NSString *path = pathDic[pathKey];
                                             NSError *err;
                                             [formData appendPartWithFileURL:[NSURL fileURLWithPath:path] name:pathKey error:&err];
                                             if (err) {
                                                 NSLog(@"upload file error %@",[err description]);
                                             }
                                         }
                                         
                                     } error:nil];
    AFHTTPRequestOperation *operation = [self.operationManager HTTPRequestOperationWithRequest:request
                                                                                       success:^(AFHTTPRequestOperation *operation, id responseObject)
                                         {
                                             
                                             [self printResponse:operation];
                                             YWAFHttpResponse *response = [self processRequestOverData:responseObject];
                                             response.parameters = parameters;
                                             response.requestTime = CACurrentMediaTime() - now;
                                             response.httpStatusCode = operation.response.statusCode;
                                             response.requestURL = operation.request.URL;
                                             response.responseData = operation.responseData;
                                             response.ret = HTTPRetCodeOK;

                                             if (response.httpStatusCode >0) {
                                                 response.ipAddress = [self getIPAddressByHostName:operation.request.URL.absoluteString];
                                             }
                                             if (overBlock) {
                                                 overBlock(response);
                                             }
                                         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                             
                                             [self print_error:error withURL:operation.request.URL  withHttpStauts:operation.response.statusCode];
                                             YWAFHttpResponse *response = [self processRequestError:error];
                                             response.parameters = parameters;
                                             response.requestTime = CACurrentMediaTime() - now;
                                             response.httpStatusCode = operation.response.statusCode;
                                             response.requestURL = operation.request.URL;
                                             response.responseData = operation.responseData;
                                             //         response.userInfo = userInfo;
                                             if (response.httpStatusCode >0) {
                                                 response.ipAddress = [self getIPAddressByHostName:operation.request.URL.absoluteString];
                                             }
                                             if (overBlock) {
                                                 overBlock(response);
                                             }
                                         }];
    
    [operation setUploadProgressBlock:^(NSUInteger __unused bytesWritten,
                                        long long totalBytesWritten,
                                        long long totalBytesExpectedToWrite)
     {
         float __progress = (CGFloat)totalBytesWritten/(CGFloat)totalBytesExpectedToWrite;
         NSLog(@"bytesWritten :%zi  Wrote: %lld/%lld", bytesWritten,totalBytesWritten, totalBytesExpectedToWrite);
         NSLog(@"progress:%f",__progress);
         if (progress)
         {
             progress(bytesWritten,totalBytesWritten,totalBytesExpectedToWrite);
         }

     }];
    [operation start];
}


- (void)downLoadFileWithUrl:(NSString *)fileURL
               fileSavePath:(NSString *)savePath
                   progress:(void (^)(NSProgress *downloadProgress)) downloadProgressBlock
                    success:(void (^)(NSURLResponse *response, NSURL *filePath))successBlock
                      error:(void (^)(NSError *error))errorBlock

{
    
    NSURL *url = [NSURL URLWithString:fileURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress *progress){
        
        NSLog(@"progress.fractionCompleted:%f  progress.localizedDescription:%@  progress.localizedAdditionalDescription:%@",progress.fractionCompleted,progress.localizedDescription,progress.localizedAdditionalDescription);
    } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        
        BOOL isDir = NO;
        NSError *error;
        NSFileManager *fm = [NSFileManager defaultManager];
        [fm createDirectoryAtPath:[savePath stringByDeletingLastPathComponent]
      withIntermediateDirectories:YES
                       attributes:nil
                            error:&error];
        if ([fm fileExistsAtPath:savePath isDirectory:&isDir]) {
            [fm removeItemAtPath:savePath error:nil];
        }
        return [NSURL fileURLWithPath:savePath];
        
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        
        if (!error) {
            
            if (successBlock) {
                
                successBlock(response,filePath);
            }
            NSLog(@"File downloaded to: %@", filePath);
        }else{
            
            NSLog(@"File downloaded error:%@",error.localizedDescription);
            if (errorBlock) {
                
                errorBlock(error);
            }
        }
        
    }];
    [downloadTask resume];
}



#pragma mark 网络监听
- (void)removeMicNetWorkMonitor
{
    NSLog(@"移除Mic插件网络状态监听");
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MicNetworkChangeNotification object:nil];
}
- (void)addMicNetworkMonitor
{
    WS(weakself);
    [[AFNetworkReachabilityManager sharedManager]setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
            {
                weakself.networkType = MicNetworkTypeUnknown;
                weakself.network = @"unknown";
                
            }
                break;
            case AFNetworkReachabilityStatusNotReachable:
            {
                weakself.networkType = MicNetworkTypeNotReachable;
                weakself.network = @"none";
                
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
            {
                NSString *tmpString = @"";
                if ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending) {
                    CTTelephonyNetworkInfo *telephonyInfo = [CTTelephonyNetworkInfo new];
                    if ([telephonyInfo.currentRadioAccessTechnology isEqualToString:CTRadioAccessTechnologyGPRS]) {
                        tmpString = @"2g";
                    } else if ([telephonyInfo.currentRadioAccessTechnology  isEqualToString:CTRadioAccessTechnologyEdge]) {
                        tmpString = @"2g";
                    } else if ([telephonyInfo.currentRadioAccessTechnology  isEqualToString:CTRadioAccessTechnologyWCDMA]) {
                        tmpString = @"3g";
                    } else if ([telephonyInfo.currentRadioAccessTechnology  isEqualToString:CTRadioAccessTechnologyHSDPA]) {
                        tmpString = @"3g";
                    } else if ([telephonyInfo.currentRadioAccessTechnology  isEqualToString:CTRadioAccessTechnologyHSUPA]) {
                        tmpString = @"3g";
                    } else if ([telephonyInfo.currentRadioAccessTechnology  isEqualToString:CTRadioAccessTechnologyCDMA1x]) {
                        tmpString = @"3g";
                    } else if ([telephonyInfo.currentRadioAccessTechnology  isEqualToString:CTRadioAccessTechnologyCDMAEVDORev0]) {
                        tmpString = @"3g";
                    } else if ([telephonyInfo.currentRadioAccessTechnology  isEqualToString:CTRadioAccessTechnologyCDMAEVDORevA]) {
                        tmpString = @"3g";
                    } else if ([telephonyInfo.currentRadioAccessTechnology  isEqualToString:CTRadioAccessTechnologyCDMAEVDORevB]) {
                        tmpString = @"3g";
                    } else if ([telephonyInfo.currentRadioAccessTechnology  isEqualToString:CTRadioAccessTechnologyeHRPD]) {
                        tmpString = @"3g";
                    } else if ([telephonyInfo.currentRadioAccessTechnology  isEqualToString:CTRadioAccessTechnologyLTE]) {
                        tmpString = @"4g";
                    }
                }else{
                    
                    tmpString = @"cellular";
                }
                weakself.network = tmpString;
                weakself.networkType = MicNetworkTypeCellular;
                
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
            {
                weakself.network = @"wifi";
                weakself.networkType = MicNetworkTypeWifi;
            }
                break;
                
            default:
                break;
        }
        NSLog(@"Mic插件网络状态监听:%@",weakself.network);
        NSNotification *notification = [NSNotification notificationWithName:MicNetworkChangeNotification object:@(weakself.networkType)];
        if (notification) {
            
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        }
    }];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

- (BOOL)isReachable
{
    if (self.networkType == MicNetworkTypeNotReachable || self.networkType == MicNetworkTypeUnknown) {
        
        return NO;
    }
    return YES;
}
- (BOOL)isWifi
{
    if (self.networkType == MicNetworkTypeWifi) {
        
        return YES;
    }
    return NO;
}
- (BOOL)isCellular
{
    if (self.networkType == MicNetworkTypeCellular) {
        
        return YES;
    }
    return NO;
}

@end
