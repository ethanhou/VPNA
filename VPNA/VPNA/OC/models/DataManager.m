//
//  DataManager.m
//  VPNA
//
//  Created by Houyushen on 17/2/19.
//  Copyright © 2017年 Houyushen. All rights reserved.
//

#import "DataManager.h"

@implementation DataManager

- (id)init {
    if (self = [super init]) {
        self.userId = [[NSUserDefaults standardUserDefaults] stringForKey:@"userid"];
        self.mobile = [[NSUserDefaults standardUserDefaults] stringForKey:@"mobile"];
        self.password = [[NSUserDefaults standardUserDefaults] stringForKey:@"password"];
    }
    return self;
}

+ (DataManager *)shareManager {
    static DataManager *manager = nil;
    static dispatch_once_t onceToken = 0;
    dispatch_once(&onceToken, ^{
        manager = [[DataManager alloc] init];
    });
    return manager;
}

- (void)configUserDict:(NSDictionary *)dict {
    self.userId = dict[@"id"];
    self.mobile = dict[@"mobile"];
    self.password = dict[@"password"];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.userId forKey:@"userid"];
    [[NSUserDefaults standardUserDefaults] setObject:self.mobile forKey:@"mobile"];
    [[NSUserDefaults standardUserDefaults] setObject:self.password forKey:@"password"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
