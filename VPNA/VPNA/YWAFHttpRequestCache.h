//
//  YWAFHttpRequestCache.h
//  YWUIKitTool
//
//  Created by 龙章辉 on 15/7/29.
//  Copyright (c) 2015年 Peter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YWObject+Utils.h"

typedef NS_ENUM(NSInteger, ClearOverDueTimeType)
{
    ClearOverDueTimeTypeDay,//缓存过期时间，以天为单位
    ClearOverDueTimeTypeSeconds,//缓存过期时间，以秒为单位
};

@interface YWAFHttpRequestCache : NSObject<NSCoding>
@property(nonatomic,strong)NSString *userId;
@property(nonatomic,strong)NSString *pathComponent;//缓存文件名，默认YWFileCache

+(YWAFHttpRequestCache *)shareRequestCache;

/**
 *  传入数据非自定义对象型时调用此方法,例如NSArray、NSDictionary等
 *
 *  @return 写入缓存是否成功
*/
- (BOOL)saveDataToFile:(NSObject *)archiverData WithKey:(NSString *)archiverKey;
- (BOOL)saveDataToFile:(NSObject *)archiverData WithKey:(NSString *)archiverKey WithUserId:(BOOL)use;


/**
 *  传入数据为自定义对象型时调用此方法，key为自定义对象的ClassName
 *
 *  @return 写入缓存是否成功
 */
- (BOOL)saveDataToFileWithObject:(NSObject *)archiverData;
- (BOOL)saveDataToFileWithObject:(NSObject *)archiverData WithUserId:(BOOL)use;


/**
 *  读取缓存数据
 *  此方法对应- (BOOL)saveDataToFile:(NSObject *)archiverData WithKey:(NSString *)archiverKey
 *
 *  @return 数据类型
 */
- (id)getDataFromFileWithKey:(NSString *)unArchiverKey;
- (id)getDataFromFileWithKey:(NSString *)unArchiverKey WithUserId:(BOOL)use;



/**
 *  读取缓存数据
 *  此方法对应- (BOOL)saveDataToFileWithObject:(NSObject *)archiverData
 *
 *  @return 数据类型
 */
- (id)getDataFromFileWithClass:(Class)unArchiverClass;
- (id)getDataFromFileWithClass:(Class)unArchiverClass WithUserId:(BOOL)use;




/**
 *  @return 缓存大小,以M为单位
 */
- (float)folderSizeAtPath;



/**
 *  清除所有缓存
 *
 *  @param success 缓存清除成功后的操作
 *  @param error   缓存清除失败后的操作
 */
- (void)clearCacheSucess:(void(^)())success Error:(void(^)())error;

- (void)clearCacheWithClass:(Class)unArchiverClass WithUserId:(BOOL)use Sucess:(void(^)())success Error:(void(^)())error;


/**
 *  按文件名清除缓存
 *
 *  @param fileName 文件名
 *  @param success 缓存清除成功后的操作
 *  @param error   缓存清除失败后的操作
 */
- (void)clearCacheWithFileName:(NSString *)fileName Sucess:(void(^)())success Error:(void(^)())error;


/**
 *  清除过期缓存
 *
 *  @param type        ClearOverDueTimeType
 *  @param validTime   缓存有效期，大于等于则过期，清除
 *  @param success     缓存清除成功后的操作
 *  @param error       缓存清除失败后的操作
 */
- (void)clearOverDueTimeCache:(NSInteger)type ValidityTime:(NSInteger)validTime
                       Sucess:(void(^)())success
                        Error:(void(^)())error;


@end
