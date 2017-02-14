//
//  ResetPwdViewController.m
//  VPNA
//
//  Created by 龙章辉 on 2017/2/14.
//  Copyright © 2017年 Houyushen. All rights reserved.
//

#import "ResetPwdViewController.h"

@interface ResetPwdViewController ()

@property(nonatomic,strong)UIView *alphView;
@property(nonatomic,strong)CustomTextField *phoneField;
@property(nonatomic,strong)CustomTextField *passwordField;
@property(nonatomic,strong)CustomTextField *authCodeField;
@property(nonatomic,strong)UIButton *codeTimeBtn;
@property(nonatomic,strong)UIButton *resetPwdBtn;
@property(nonatomic,assign)BOOL resetCodeTime;


@end

@implementation ResetPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _alphView = [[UIView alloc] init];
    [_alphView setBackgroundColor:RGBA(50, 47, 76,0.5)];
    [self.view addSubview:_alphView];
    [_alphView mas_makeConstraints:^(MASConstraintMaker *make){
        
        make.left.mas_offset(20);
        make.right.mas_offset(-20);
        make.height.mas_equalTo(300);
        make.top.equalTo(self.logoView.mas_bottom).mas_offset(40);
    }];
    [self initInterface];
}

- (void)initInterface
{
    _phoneField = [self createTextField:@"请输入手机号"
                      withLeftImageName:@"phone_icon-1"];
    [_alphView addSubview:_phoneField];
    
    UIView *lineView = [[UIView alloc] init];
    [lineView setBackgroundColor:RGB(235, 236, 238)];
    [_alphView addSubview:lineView];

    _passwordField = [self createTextField:@"请输入密码"
                         withLeftImageName:@"password_icon-1"];
    [_alphView addSubview:_passwordField];
    
    UIView *lineView2 = [[UIView alloc] init];
    [lineView2 setBackgroundColor:RGB(235, 236, 238)];
    [_alphView addSubview:lineView2];

    _authCodeField = [self createTextField:@"请输入验证码"
                         withLeftImageName:@"authcode_icon-1"];
    [_alphView addSubview:_authCodeField];
    
    
    _codeTimeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_codeTimeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_codeTimeBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [_codeTimeBtn setBackgroundColor:[UIColor whiteColor]];
    _codeTimeBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [_codeTimeBtn addTarget:self action:@selector(clickedRightCodeTimeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_alphView addSubview:_codeTimeBtn];
    
    UIView *lineView3 = [[UIView alloc] init];
    [lineView3 setBackgroundColor:RGB(235, 236, 238)];
    [_alphView addSubview:lineView3];
    
    _resetPwdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_resetPwdBtn setTitle:@"重置密码" forState:UIControlStateNormal];
    [_resetPwdBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _resetPwdBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    _resetPwdBtn.layer.cornerRadius = 4;
    [_resetPwdBtn setBackgroundColor:RGB(93, 94, 105)];
    [_resetPwdBtn addTarget:self action:@selector(clickedResetPwd:) forControlEvents:UIControlEventTouchUpInside];
    [_alphView addSubview:_resetPwdBtn];

    [_phoneField mas_makeConstraints:^(MASConstraintMaker *make){
        
        make.left.mas_offset(20);
        make.right.mas_offset(-20);
        make.top.mas_offset(40);
        make.height.mas_equalTo(45);
    }];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make){
        
        make.top.equalTo(_phoneField.mas_bottom);
        make.left.equalTo(_phoneField.mas_left);
        make.right.equalTo(_phoneField.mas_right);
        make.height.mas_equalTo(1);
    }];
    [_passwordField mas_makeConstraints:^(MASConstraintMaker *make){
        
        make.top.equalTo(lineView.mas_bottom);
        make.left.equalTo(_phoneField.mas_left);
        make.right.equalTo(_phoneField.mas_right);
        make.height.equalTo(_phoneField.mas_height);
    }];
    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make){
        
        make.top.equalTo(_passwordField.mas_bottom);
        make.left.equalTo(_phoneField.mas_left);
        make.right.equalTo(_phoneField.mas_right);
        make.height.mas_equalTo(1);
    }];
    [_authCodeField mas_makeConstraints:^(MASConstraintMaker *make){
        
        make.top.equalTo(lineView2.mas_bottom);
        make.left.equalTo(_phoneField.mas_left);
        make.right.equalTo(_codeTimeBtn.mas_left);
        make.height.equalTo(_phoneField.mas_height);
    }];
    [lineView3 mas_makeConstraints:^(MASConstraintMaker *make){
        
        make.centerY.equalTo(_authCodeField.mas_centerY);
        make.left.equalTo(_authCodeField.mas_right);
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(30);
    }];
    [_codeTimeBtn mas_makeConstraints:^(MASConstraintMaker *make){
        
        make.top.equalTo(lineView2.mas_bottom);
        make.left.equalTo(_authCodeField.mas_right);
        make.right.equalTo(_phoneField.mas_right);
        make.width.mas_equalTo(90);
        make.height.equalTo(_phoneField.mas_height);
    }];
    [_resetPwdBtn mas_makeConstraints:^(MASConstraintMaker *make){
        
        make.centerX.mas_offset(0);
        make.top.equalTo(_authCodeField.mas_bottom).mas_offset(40);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(40);
    }];
}

- (void)clickedResetPwd:(UIButton *)sender
{
    NSLog(@"重置密码");
}

- (CustomTextField *)createTextField:(NSString *)placeString withLeftImageName:(NSString *)imaName
{
    UIImage *ima = [UIImage imageNamed:imaName];
    UIImageView *_leftView = [[UIImageView alloc] init];
    [_leftView setImage:ima];
    [_leftView setFrame:CGRectMake(0, 0, 20, 20)];
    CustomTextField *field = [[CustomTextField alloc] init];
    field.placeholder = placeString;
    field.leftView = _leftView;
    field.leftViewMode = UITextFieldViewModeAlways;
    field.font = [UIFont systemFontOfSize:12.0];
    field.delegate = self;
    field.textColor = [UIColor grayColor];
    field.borderStyle = UITextBorderStyleNone;
    [field setBackgroundColor:[UIColor whiteColor]];
    return field;
}


- (void)clickedRightCodeTimeBtn:(UIButton *)timeBtn
{
    self.resetCodeTime = NO;
    __block int timeout=60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0)
        {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [timeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                timeBtn.userInteractionEnabled = YES;
                timeBtn.selected = NO;
                
            });
        }else{
            int seconds = timeout % 61;
            NSString *strTime = [NSString stringWithFormat:@"%.1d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (self.resetCodeTime)
                {
                    dispatch_source_cancel(_timer);
                    [timeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                    timeBtn.userInteractionEnabled = YES;
                    timeBtn.selected = NO;
                }
                else
                {
                    timeBtn.selected = YES;
                    [timeBtn setTitle:[NSString stringWithFormat:@"%@s重新获取",strTime] forState:UIControlStateSelected];
                    [timeBtn setTitleColor:RGB(209, 209, 209) forState:UIControlStateSelected];
                    timeBtn.userInteractionEnabled = NO;
                    
                }
                
                
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
