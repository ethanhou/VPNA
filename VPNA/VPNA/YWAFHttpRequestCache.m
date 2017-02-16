//
//  YWAFHttpRequestCache.m
//  YWUIKitTool
//
//  Created by 龙章辉 on 15/7/29.
//  Copyright (c) 2015年 Peter. All rights reserved.
//

#import "YWAFHttpRequestCache.h"

#define cacheDirectoryName @"YWCacheRootDirectory"

@implementation YWAFHttpRequestCache
@synthesize userId;

+(YWAFHttpRequestCache *)shareRequestCache
{
    static YWAFHttpRequestCache *sharedInstance = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[YWAFHttpRequestCache alloc] init];
    });
    return sharedInstance;
}
- (instancetype)init
{
    if (self==[super init])
    {
        _pathComponent = @"YWFileCache";
    }
    return self;
}

-(NSString *)pathForRequestCache
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES);
    NSString *cachesDirectory = [paths objectAtIndex:0];
    cachesDirectory = [[cachesDirectory stringByAppendingPathComponent:cacheDirectoryName] stringByAppendingPathComponent:self.pathComponent];
    NSFileManager *fileManager=[NSFileManager defaultManager];
    NSError *error;
    if(![fileManager fileExistsAtPath:cachesDirectory])
    {
        [fileManager createDirectoryAtPath:cachesDirectory withIntermediateDirectories:YES attributes:nil error:&error];
        if(!error)
        {
            NSLog(@"%@",[error description]);
        }
    }
    NSLog(@"cachesDirectory:%@",cachesDirectory);
    return cachesDirectory;
}

- (BOOL)saveDataToFile:(NSObject *)archiverData WithKey:(NSString *)archiverKey
{
   return [self saveDataToFile:archiverData WithKey:archiverKey WithUserId:NO];
}
- (BOOL)saveDataToFile:(NSObject *)archiverData WithKey:(NSString *)archiverKey WithUserId:(BOOL)use
{
    NSString *UID=  StringValue(self.userId);
    NSString *component = [NSString stringWithFormat:@"/%@%@",archiverKey,use?UID:@""];
    //归档
    NSString *dataPath = [[self pathForRequestCache] stringByAppendingPathComponent:component];
    return [NSKeyedArchiver archiveRootObject:archiverData toFile:dataPath];
    //    NSMutableData *data = [NSMutableData data];
    //    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    //    [archiver encodeObject:archiverData forKey:archiverKey];
    //    [archiver finishEncoding];
    //    //将数据写入文件里
    //    [data writeToFile:dataPath atomically:YES];
}



- (BOOL)saveDataToFileWithObject:(NSObject *)archiverData
{
    return  [self saveDataToFileWithObject:archiverData WithUserId:NO];
}
- (BOOL)saveDataToFileWithObject:(NSObject *)archiverData WithUserId:(BOOL)use
{
    NSString *UID= StringValue(userId);
    NSString *className = NSStringFromClass(archiverData.class);
    NSString *compont = [NSString stringWithFormat:@"/%@%@",className,use?UID:@""];
    NSString *dataPath = [[self pathForRequestCache] stringByAppendingPathComponent:compont];
    return [NSKeyedArchiver archiveRootObject:archiverData toFile:dataPath];
}



- (id)getDataFromFileWithKey:(NSString *)unArchiverKey
{
   
    return [self getDataFromFileWithKey:unArchiverKey WithUserId:NO];
}
- (id)getDataFromFileWithKey:(NSString *)unArchiverKey WithUserId:(BOOL)use
{
    NSString *UID = StringValue(userId);
    NSString *compont = [NSString stringWithFormat:@"/%@%@",unArchiverKey,use?UID:@""];
    //反归档，从文件中取出数据
    NSString *dataPath = [[self pathForRequestCache] stringByAppendingPathComponent:compont];
    id obj = nil;
    @try {
        obj = [NSKeyedUnarchiver unarchiveObjectWithFile:dataPath];
    }
    @catch (NSException *exception) {
        NSLog(@"Load data from cache was failed with exception: %@", [exception reason]);
    }
    @finally {
        return obj;
    }
    //    NSMutableData *data = [NSMutableData dataWithContentsOfFile:dataPath];
    //    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:data];
    //    return [unarchiver decodeObjectForKey:unArchiverKey];
}


- (id)getDataFromFileWithClass:(Class)unArchiverClass
{
    return [self getDataFromFileWithClass:unArchiverClass WithUserId:NO];
}
- (id)getDataFromFileWithClass:(Class)unArchiverClass WithUserId:(BOOL)use
{
    NSString *UID = StringValue(self.userId);
    NSString *className = NSStringFromClass(unArchiverClass);
    NSString *compont = [NSString stringWithFormat:@"/%@%@",className,use?UID:@""];
    //反归档，从文件中取出数据
    NSString *dataPath = [[self pathForRequestCache] stringByAppendingPathComponent:compont];
    id obj = nil;
    @try {
        obj = [NSKeyedUnarchiver unarchiveObjectWithFile:dataPath];
    }
    @catch (NSException *exception) {
        NSLog(@"Load data from cache was failed with exception: %@", [exception reason]);
    }
    @finally {
        return obj;
    }
}




//单个文件的大小
- (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        NSDictionary *attributes = [manager attributesOfItemAtPath:filePath error:nil];
        return  attributes.fileSize;
    }
    return 0;
}

//遍历文件夹获得文件夹大小，返回多少M
- (float ) folderSizeAtPath
{
    NSString *folderPath = [self pathForRequestCache];
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath])
    return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil)
    {
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}


- (void)clearCacheSucess:(void(^)())success Error:(void(^)())error
{
    
    __block BOOL clearStaus = NO;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, queue, ^{
        
        NSFileManager* manager = [NSFileManager defaultManager];
        NSString *filePath = [self pathForRequestCache];
        if ([manager fileExistsAtPath:filePath])
        {
            clearStaus = [manager removeItemAtPath:filePath error:nil];
        }
    });
    // 监听群组任务通知
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
       
        if (clearStaus)
        {
            if (success)
            {
                success();
            }
        }
        else
        {
            if (error)
            {
                error();
            }
        }
    });

}

- (void)clearCacheWithClass:(Class)unArchiverClass WithUserId:(BOOL)use Sucess:(void(^)())success Error:(void(^)())error
{
    NSString *UID = StringValue(self.userId);
    NSString *className = NSStringFromClass(unArchiverClass);
    NSString *compont = [NSString stringWithFormat:@"/%@%@",className,use?UID:@""];
    NSString *filePath = [[self pathForRequestCache] stringByAppendingPathComponent:compont];
    __block BOOL clearStaus = NO;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, queue, ^{
        
        NSFileManager* manager = [NSFileManager defaultManager];
        if ([manager fileExistsAtPath:filePath])
        {
            clearStaus = [manager removeItemAtPath:filePath error:nil];
        }
    });
    // 监听群组任务通知
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
        if (clearStaus)
        {
            if (success)
            {
                success();
            }
        }
        else
        {
            if (error)
            {
                error();
            }
        }
        
    });
}

- (void)clearCacheWithFileName:(NSString *)fileName Sucess:(void(^)())success Error:(void(^)())error
{
    __block BOOL clearStaus = NO;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, queue, ^{
        
        NSString *folderPath = [self pathForRequestCache];
        NSFileManager* manager = [NSFileManager defaultManager];
        NSString* filePath = [folderPath stringByAppendingPathComponent:fileName];
        if ([manager fileExistsAtPath:filePath])
        {
            clearStaus = [manager removeItemAtPath:filePath error:nil];
        }
    });
    // 监听群组任务通知
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
        if (clearStaus)
        {
            if (success)
            {
                success();
            }
        }
        else
        {
            if (error)
            {
                error();
            }
        }
        
    });
}

- (void)clearOverDueTimeCache:(NSInteger)type ValidityTime:(NSInteger)validTime
                                              Sucess:(void(^)())success
                                              Error:(void(^)())error
{
    __block BOOL clearStaus = NO;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, queue, ^{
        
        NSString *folderPath = [self pathForRequestCache];
        NSFileManager* manager = [NSFileManager defaultManager];
        if (![manager fileExistsAtPath:folderPath])
            return;
        NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
        NSString* fileName;
        while ((fileName = [childFilesEnumerator nextObject]) != nil)
        {
            NSString* filePath = [folderPath stringByAppendingPathComponent:fileName];
            if ([manager fileExistsAtPath:filePath])
            {
                NSDictionary *attributes = [manager attributesOfItemAtPath:filePath error:nil];
                NSString *dateString = [NSString stringWithFormat:@"%@",[attributes fileModificationDate]];
                //日期格式转换
                NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
                [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss Z"];
                NSDate *formatterDate = [inputFormatter dateFromString:dateString];
                //            NSLog(@"文件最后修改时间:%@",[inputFormatter stringFromDate:formatterDate]);
                
                unsigned int unitFlags = type==ClearOverDueTimeTypeDay?NSDayCalendarUnit:NSSecondCalendarUnit;
                NSCalendar *cal = [NSCalendar currentCalendar];
                NSDateComponents *d = [cal components:unitFlags fromDate:formatterDate toDate:[NSDate date] options:0];
                NSInteger time = type==ClearOverDueTimeTypeDay?[d day]:[d second];
                if (time >= validTime)
                {
                    clearStaus = [manager removeItemAtPath:filePath error:nil];
                    if (type==ClearOverDueTimeTypeDay)
                    {
                        NSLog(@"缓存文件：%@--->缓存有效时间为%d天,超过%d天,已过期被自动清理",fileName,(int)time,(int)validTime);
                    }
                    else
                    {
                        NSLog(@"缓存文件：%@--->缓存有效时间为%d秒,超过%d秒,已过期被自动清理",fileName,(int)time,(int)validTime);
                        
                    }
                }
            }
        }
        
    });
    // 监听群组任务通知
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        
        if (clearStaus)
        {
            if (success)
            {
                success();
            }
        }
        else
        {
            if (error)
            {
                error();
            }
        }
        
    });
    
    
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self == [super init]) {
        
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)aCoder;
{
    
}

@end
