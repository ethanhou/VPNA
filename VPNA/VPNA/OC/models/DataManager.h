//
//  DataManager.h
//  VPNA
//
//  Created by Houyushen on 17/2/19.
//  Copyright © 2017年 Houyushen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataManager : NSObject

@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *deviceId;

+ (DataManager *)shareManager;
- (void)configUserDict:(NSDictionary *)dict;

@end
