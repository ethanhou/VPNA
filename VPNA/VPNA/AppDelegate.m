//
//  AppDelegate.m
//  VPNA
//
//  Created by Houyushen on 16/12/25.
//  Copyright © 2016年 Houyushen. All rights reserved.
//

#import "AppDelegate.h"
#import "QWTabBarController.h"
#import "AFNetworking.h"
#import "LoginViewController.h"
#import "YWAFHttpManager.h"
#import <SMS_SDK/SMSSDK.h>


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //初始化应用，appKey和appSecret从后台申请得
    [SMSSDK registerApp:@"1b19b4f96c500"
             withSecret:@"7f6a684e2d18e0cf4e9022372f40e1fb"];
    
    [[YWAFHttpManager shareHttpManager] requestPostURL:@"http://112.74.48.30:8080/app/init"
                                        withParameters:@{@"type" : @(10)}
                                          withUserInfo:nil
                                      withReqOverBlock:^(YWAFHttpResponse *response) {
                                          NSLog(@"成功");
                                      }];
    
     self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    LoginViewController *loginCtr = [[LoginViewController alloc] init];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:loginCtr];
    self.window.rootViewController = navi;
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    NSLog(@"vpn applicationWillResignActive");

    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSLog(@"vpn applicationDidEnterBackground");

    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    NSLog(@"vpn applicationWillEnterForeground");

    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSLog(@"vpn applicationDidBecomeActive");
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    NSLog(@"vpn applicationWillTerminate");

    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
