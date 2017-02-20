//
//  KeyChainStore.h
//  VPNA
//
//  Created by Houyushen on 17/2/20.
//  Copyright © 2017年 Houyushen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyChainStore : NSObject

+ (void)save:(NSString *)service data:(id)data;
+ (id)load:(NSString *)service;
+ (void)deleteKeyData:(NSString *)service;

@end
