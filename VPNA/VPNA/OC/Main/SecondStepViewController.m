//
//  SecondStepViewController.m
//  VPNA
//
//  Created by 龙章辉 on 2017/2/15.
//  Copyright © 2017年 Houyushen. All rights reserved.
//

#import "SecondStepViewController.h"
#import "UILabel+YBAttributeTextTapAction.h"
#import "ThirdStepViewController.h"

#define ciscoUrlString @"http://www.cisco.com/en/US/docs/security/vpnclient/anyconnect/anyconnect30/release/notes/rn-ac3.0-iOS.html"

@interface SecondStepViewController ()<YBAttributeTapActionDelegate>

@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UIView *alphView;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *contentLabel;
@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)UIButton *nextBtn;

@end

@implementation SecondStepViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _scrollView = [[UIScrollView alloc] init];
    [_scrollView setBackgroundColor:[UIColor clearColor]];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.bounces = NO;
    [self.view addSubview:_scrollView];

    
    _alphView = [[UIView alloc] init];
    [_alphView setBackgroundColor:RGBA(50, 47, 76,0.5)];
    [_scrollView addSubview:_alphView];

    _titleLabel = [[UILabel alloc] init];
    [_titleLabel setBackgroundColor:[UIColor clearColor]];
    [_titleLabel setFont:[UIFont systemFontOfSize:16.0]];
    [_titleLabel setText:@"仅需三步，世界畅联"];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [_titleLabel setTextColor:[UIColor whiteColor]];
    [_alphView addSubview:_titleLabel];
    
    NSString *content = [NSString stringWithFormat:@"第二步\n\n\n请点击以下链接下载试用版证书并输入证书密码:：123456\n\n%@",ciscoUrlString];
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
    NSRange range2 = [content rangeOfString:@"试用版"];
    NSRange range3 = [content rangeOfString:@"123456"];

    NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc] initWithString:_contentLabel.text];
    [attribtStr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:range];
    [attribtStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:range2];
    [attribtStr addAttribute:NSForegroundColorAttributeName value:[UIColor brownColor] range:range2];
    [attribtStr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:range3];
    [attribtStr addAttribute:NSForegroundColorAttributeName value:[UIColor brownColor] range:range3];
    _contentLabel.attributedText = attribtStr;

    
    _imageView = [[UIImageView alloc] init];
    [_imageView setImage:[UIImage imageNamed:@"free_step2"]];
    [_alphView addSubview:_imageView];
    
    _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
    [_nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _nextBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    _nextBtn.layer.cornerRadius = 4;
    [_nextBtn setBackgroundColor:RGB(93, 94, 105)];
    [_nextBtn addTarget:self action:@selector(gotoNextStepViewController:) forControlEvents:UIControlEventTouchUpInside];
    [_alphView addSubview:_nextBtn];
    
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make){
        
        make.left.equalTo(self.view.mas_left).mas_offset(20);
        make.right.equalTo(self.view.mas_right).mas_offset(-20);
        make.top.equalTo(self.logoView.mas_bottom).mas_offset(40);
        make.bottom.mas_offset(-40);
    }];
    [_alphView mas_makeConstraints:^(MASConstraintMaker *make){
        
        make.left.right.top.bottom.mas_offset(0);
        make.width.equalTo(_scrollView.mas_width);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make){
        
        make.top.mas_offset(30);
        make.left.right.mas_offset(0);
    }];
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make){
        
        make.top.equalTo(_titleLabel.mas_bottom).mas_offset(30);
        make.left.mas_offset(20);
        make.right.mas_offset(-20);
    }];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make){
        
        make.left.mas_equalTo(10);
        make.right.mas_offset(-10);
        make.top.equalTo(_contentLabel.mas_bottom).mas_offset(20);
    }];
    [_nextBtn mas_makeConstraints:^(MASConstraintMaker *make){
        
        make.top.equalTo(_imageView.mas_bottom).mas_offset(40);
        make.centerX.mas_offset(0);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(40);
        make.bottom.mas_offset(-20);
    }];
}

- (void)yb_attributeTapReturnString:(NSString *)string range:(NSRange)range index:(NSInteger)index
{
    if ([string isEqualToString:ciscoUrlString]) {
      
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:ciscoUrlString]];
    }
}


- (void)gotoNextStepViewController:(UIButton *)sender
{
    ThirdStepViewController *thirdCtr = [[ThirdStepViewController alloc] init];
    [self.navigationController pushViewController:thirdCtr animated:YES];
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
