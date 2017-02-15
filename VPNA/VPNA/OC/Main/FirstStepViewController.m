//
//  FirstStepViewController.m
//  VPNA
//
//  Created by 龙章辉 on 2017/2/15.
//  Copyright © 2017年 Houyushen. All rights reserved.
//

#import "FirstStepViewController.h"
#import "UILabel+YBAttributeTextTapAction.h"
#import "SecondStepViewController.h"

#define ciscoUrlString @"http://www.cisco.com/en/US/docs/security/vpnclient/anyconnect/anyconnect30/release/notes/rn-ac3.0-iOS.html"

@interface FirstStepViewController ()<YBAttributeTapActionDelegate>

@property(nonatomic,strong)UIView *alphView;
@property(nonatomic,strong)UIButton *nextBtn;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *contentLabel;


@end

@implementation FirstStepViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _alphView = [[UIView alloc] init];
    [_alphView setBackgroundColor:RGBA(50, 47, 76,0.5)];
    [self.view addSubview:_alphView];
    [_alphView mas_makeConstraints:^(MASConstraintMaker *make){
        
        make.left.mas_offset(20);
        make.right.mas_offset(-20);
        make.height.mas_equalTo(360);
        make.top.equalTo(self.logoView.mas_bottom).mas_offset(40);
    }];
    _titleLabel = [[UILabel alloc] init];
    [_titleLabel setBackgroundColor:[UIColor clearColor]];
    [_titleLabel setFont:[UIFont systemFontOfSize:16.0]];
    [_titleLabel setText:@"仅需三步，世界畅联"];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [_titleLabel setTextColor:[UIColor whiteColor]];
    [_alphView addSubview:_titleLabel];
    
    NSString *content = [NSString stringWithFormat:@"第一步\n\n\n请点击以下链接一键安装思科Any Connect\n\n%@",ciscoUrlString];
    _contentLabel = [[UILabel alloc] init];
    [_contentLabel setBackgroundColor:[UIColor clearColor]];
    [_contentLabel setFont:[UIFont systemFontOfSize:14.0]];
    [_contentLabel setText:content];
    _contentLabel.textAlignment = NSTextAlignmentLeft;
    _contentLabel.numberOfLines = 0;
    [_contentLabel setTextColor:[UIColor whiteColor]];
    _contentLabel.userInteractionEnabled = YES;
    _contentLabel.enabledTapEffect = YES;
    [_alphView addSubview:_contentLabel];
    [_contentLabel yb_addAttributeTapActionWithStrings:@[ciscoUrlString] delegate:self];

    NSRange range = [content rangeOfString:ciscoUrlString];
    NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc] initWithString:_contentLabel.text];
    [attribtStr addAttributes:attribtDic range:range];
    _contentLabel.attributedText = attribtStr;
    
    _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [_nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _nextBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    _nextBtn.layer.cornerRadius = 4;
    [_nextBtn setBackgroundColor:RGB(93, 94, 105)];
    [_nextBtn addTarget:self action:@selector(gotoNextStepViewController:) forControlEvents:UIControlEventTouchUpInside];
    [_alphView addSubview:_nextBtn];

    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make){
        
        make.top.mas_offset(30);
        make.left.right.mas_offset(0);
    }];
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make){
        
        make.top.equalTo(_titleLabel.mas_bottom).mas_offset(30);
        make.left.mas_offset(20);
        make.right.mas_offset(-20);
    }];
    [_nextBtn mas_makeConstraints:^(MASConstraintMaker *make){
        
        make.top.equalTo(_contentLabel.mas_bottom).mas_offset(40);
        make.centerX.mas_offset(0);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(40);
    }];
}

- (void)yb_attributeTapReturnString:(NSString *)string range:(NSRange)range index:(NSInteger)index
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:ciscoUrlString]];
}

- (void)gotoNextStepViewController:(UIButton *)sender
{
    SecondStepViewController *secondCtr = [[SecondStepViewController alloc] init];
    [self.navigationController pushViewController:secondCtr animated:YES];
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
