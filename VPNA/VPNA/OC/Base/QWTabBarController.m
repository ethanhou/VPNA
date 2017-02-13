//
//  QWTabBarController.m
//  VPNA
//  Created by Houyushen on 16/12/25.
//  Copyright © 2016年 Houyushen. All rights reserved.
//

#import "QWTabBarController.h"
#import "QWNavitionController.h"

#import "PackagesViewController.h"
@interface QWTabBarController ()

@end

@implementation QWTabBarController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self addChildViewControllers];
}
- (void)addChildViewControllers
{
#warning  添加 被TabBarCtl 控制的视图控制器 名称
    //视图控制器名称
    NSMutableArray *array = [NSMutableArray arrayWithArray:@[@"PackagesViewController",@"QWBaseViewController",@"QWBaseViewController",@"QWBaseViewController"]];
#warning Set TabBarItem Nomal Icon Name
    NSArray *imgArray = @[@"buy_icon",@"support",@"news",@"my"];
#warning Set TabBarItem selected Icon Name
    NSArray *selectImageArray = @[@"buy_icon_press",@"support_press",@"news_press",@"my_press"];
#warning Set TabBarItem title
    NSArray *titles = @[@"套餐",@"支持",@"新闻",@"我的"];
    for(int i =0;i<array.count;i++)
    {
        UIViewController *vc = [[NSClassFromString(array[i]) alloc] init];
        QWNavitionController *nav = [[QWNavitionController alloc] initWithRootViewController:vc];
        vc.title = titles[i];
        nav.tabBarItem.title = titles[i];
        nav.tabBarItem.image = IMG(imgArray[i]);
        nav.tabBarItem.selectedImage = [IMG(selectImageArray[i]) imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [array replaceObjectAtIndex:i withObject:nav];
    }
    self.viewControllers = array;
    self.tabBar.tintColor = MAIN_COLOR;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
 
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
