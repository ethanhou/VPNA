//
//  HomeViewController.m
//  VPNA
//
//  Created by 龙章辉 on 2017/2/14.
//  Copyright © 2017年 Houyushen. All rights reserved.
//

#import "HomeViewController.h"
#import "FirstStepViewController.h"
#import "PayViewController.h"
#import "CountDownViewController.h"

@interface HomeViewController ()

@property(nonatomic,strong)UIButton *freeBtn;
@property(nonatomic,strong)UIButton *chargeBtn;

@end

@implementation HomeViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.logoView.hidden = YES;
    
    UIImage *image = [UIImage imageNamed:@"free_icon"];
    
    _freeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_freeBtn setImage:image forState:UIControlStateNormal];
    [_freeBtn setTitle:@"免费试用" forState:UIControlStateNormal];
    [_freeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
    [_freeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _freeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_freeBtn addTarget:self action:@selector(clickedFreeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_freeBtn];
    
    image = [UIImage imageNamed:@"charge_icon"];
    _chargeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_chargeBtn setImage:image forState:UIControlStateNormal];
    [_chargeBtn setTitle:@"正式使用" forState:UIControlStateNormal];
    [_chargeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 10)];
    [_chargeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _chargeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [_chargeBtn addTarget:self action:@selector(clickedChargeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_chargeBtn];
    
    [_freeBtn mas_makeConstraints:^(MASConstraintMaker *make){
        
        make.centerX.mas_offset(0);
        make.centerY.mas_offset(-20);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(200);
    }];
    [_chargeBtn mas_makeConstraints:^(MASConstraintMaker *make){
        
        make.centerX.mas_offset(0);
        make.top.equalTo(_freeBtn.mas_bottom).mas_offset(30);
        make.height.equalTo(_freeBtn.mas_height);
        make.width.equalTo(_freeBtn.mas_width);
    }];
}

- (void)clickedFreeBtn:(UIButton *)sender
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSLog(@"免费试用");
    [[YWAFHttpManager shareHttpManager] requestPostURL:@"http://112.74.48.30:8080/order/newOrder"
                                        withParameters:@{@"serviceId":@(1), @"userId":@([DataManager shareManager].userId), @"deviceId":[DataManager shareManager].deviceId, @"day":@(0)}
                                          withUserInfo:nil
                                      withReqOverBlock:^(YWAFHttpResponse *response) {
                                          
                                          if (response.ret == HTTPRetCodeOK) {
                                              NSDictionary *dict = (NSDictionary *)response.data;
                                              NSString *url = [NSString stringWithFormat:@"%@/%@.p12",dict[@"VpOrder"][@"p12"], dict[@"VpOrder"][@"payNumber"]];
                                              NSURL *p12 = [NSURL URLWithString:url];
                                              [[UIApplication sharedApplication] openURL:p12];
                                          }
                                          [MBProgressHUD hideHUDForView:self.view animated:YES];
//                                          FirstStepViewController *firstCtr = [[FirstStepViewController alloc] init];
//                                          [self.navigationController pushViewController:firstCtr animated:YES];
                                      }];
}

- (void)clickedChargeBtn:(UIButton *)sender
{
    NSLog(@"正式使用");
    PayViewController *payCtr = [[PayViewController alloc] init];
    [self.navigationController pushViewController:payCtr animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
