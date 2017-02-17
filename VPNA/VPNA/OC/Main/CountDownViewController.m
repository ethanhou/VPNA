//
//  CountDownViewController.m
//  VPNA
//
//  Created by Houyushen on 17/2/17.
//  Copyright © 2017年 Houyushen. All rights reserved.
//

#import "CountDownViewController.h"
#import "NSMutableAttributedString+Ext.h"
#import "NSAttributedString+Ext.h"
#import "FirstStepViewController.h"

@interface CountDownViewController ()
@property (nonatomic, strong) UIView *alphView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *countDownLabel;
@property (nonatomic, strong) UIButton *nextBtn;
@end

@implementation CountDownViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _alphView = [[UIView alloc] init];
    [_alphView setBackgroundColor:RGBA(50, 47, 76,0.5)];
    [self.view addSubview:_alphView];
    [_alphView mas_makeConstraints:^(MASConstraintMaker *make){
        
        make.left.mas_offset(20);
        make.right.mas_offset(-20);
        make.height.mas_equalTo(300);
        make.top.equalTo(self.logoView.mas_bottom).mas_offset(40);
    }];
    
    _titleLabel = [[UILabel alloc] init];
    [_titleLabel setBackgroundColor:[UIColor clearColor]];
    [_titleLabel setFont:[UIFont systemFontOfSize:22.0]];
    [_titleLabel setText:@"您还可以畅联"];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [_titleLabel setTextColor:[UIColor whiteColor]];
    [_alphView addSubview:_titleLabel];
    
    _countDownLabel = [[UILabel alloc] init];
    [_countDownLabel setBackgroundColor:[UIColor clearColor]];
    _countDownLabel.textAlignment = NSTextAlignmentCenter;
    _countDownLabel.numberOfLines = 0;
    [_countDownLabel setTextColor:[UIColor whiteColor]];
    _countDownLabel.userInteractionEnabled = YES;
    [_alphView addSubview:_countDownLabel];
    
    NSAttributedString *countDown = \
    [NSAttributedString string:@"100天"
                        color:[UIColor greenColor]
                          font:[UIFont boldSystemFontOfSize:50]
                         block:^(NSMutableAttributedString *mString, NSString *string) {
                             NSRange range = [string rangeOfString:@"天"];
                             [mString setFont:[UIFont systemFontOfSize:20] inRange:range];
                             [mString setColor:[UIColor whiteColor] inRange:range];
                         }];
    _countDownLabel.attributedText = countDown;
    
    
    _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_nextBtn setTitle:@"继续使用" forState:UIControlStateNormal];
    [_nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _nextBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    _nextBtn.layer.cornerRadius = 4;
    [_nextBtn setBackgroundColor:RGB(93, 94, 105)];
    [_nextBtn addTarget:self action:@selector(nextBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_alphView addSubview:_nextBtn];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_offset(20);
        make.right.mas_offset(-20);
        make.height.mas_equalTo(40);
        make.top.mas_offset(40);
    }];
    
    [_countDownLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_offset(20);
        make.right.mas_offset(-20);
        make.height.mas_equalTo(50);
        make.top.equalTo(self.titleLabel.mas_bottom).mas_offset(40);
    }];
    
    [_nextBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerX.mas_offset(0);
        make.width.mas_offset(80);
        make.height.mas_equalTo(38);
        make.bottom.mas_equalTo(-40);
    }];
}

- (void)nextBtnClicked:(id)sender {
    FirstStepViewController *firstCtr = [[FirstStepViewController alloc] init];
    [self.navigationController pushViewController:firstCtr animated:YES];
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
