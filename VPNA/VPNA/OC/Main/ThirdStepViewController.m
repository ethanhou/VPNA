//
//  ThirdStepViewController.m
//  VPNA
//
//  Created by 龙章辉 on 2017/2/15.
//  Copyright © 2017年 Houyushen. All rights reserved.
//

#import "ThirdStepViewController.h"

@interface ThirdStepViewController ()

@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UIView *alphView;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *contentLabel;
@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)UIButton *nextBtn;
@property(nonatomic,strong)UILabel *tipsLabel;

@end

@implementation ThirdStepViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _scrollView = [[UIScrollView alloc] init];
    [_scrollView setBackgroundColor:[UIColor clearColor]];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.bounces = NO;
    [self.view addSubview:_scrollView];
    
    _tipsLabel = [[UILabel alloc] init];
    [_tipsLabel setBackgroundColor:[UIColor clearColor]];
    [_tipsLabel setFont:[UIFont systemFontOfSize:12.0]];
    [_tipsLabel setTextColor:[UIColor brownColor]];
    [_tipsLabel setText:@"试用版仅限24小时体验,如需继续使用可选择正式版"];
    _tipsLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_tipsLabel];
    [_tipsLabel mas_makeConstraints:^(MASConstraintMaker *make){
        
        make.left.right.mas_offset(0);
        make.top.equalTo(_scrollView.mas_bottom).mas_offset(20);
    }];
    
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
    
    NSString *content = @"第三步\n\n\n请打开第一步安装好的思科AnyConnect App,并按下图步骤进行操作。";
    _contentLabel = [[UILabel alloc] init];
    [_contentLabel setBackgroundColor:[UIColor clearColor]];
    [_contentLabel setFont:[UIFont systemFontOfSize:14.0]];
    [_contentLabel setText:content];
    _contentLabel.textAlignment = NSTextAlignmentLeft;
    _contentLabel.numberOfLines = 0;
    [_contentLabel setTextColor:[UIColor whiteColor]];
    _contentLabel.userInteractionEnabled = YES;
    [_alphView addSubview:_contentLabel];
    

    _imageView = [[UIImageView alloc] init];
    [_imageView setImage:[UIImage imageNamed:@"free_step3"]];
    [_alphView addSubview:_imageView];
    
    _nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_nextBtn setTitle:@"完成" forState:UIControlStateNormal];
    [_nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _nextBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    _nextBtn.layer.cornerRadius = 4;
    [_nextBtn setBackgroundColor:RGB(93, 94, 105)];
    [_nextBtn addTarget:self action:@selector(done:) forControlEvents:UIControlEventTouchUpInside];
    [_alphView addSubview:_nextBtn];
    
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make){
        
        make.left.equalTo(self.view.mas_left).mas_offset(20);
        make.right.equalTo(self.view.mas_right).mas_offset(-20);
        make.top.equalTo(self.logoView.mas_bottom).mas_offset(40);
        make.bottom.mas_offset(-50);
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

- (void)done:(UIButton *)sender
{
    
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
