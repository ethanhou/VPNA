//
//  RegisterViewController.m
//  VPNA
//
//  Created by 龙章辉 on 2017/2/13.
//  Copyright © 2017年 Houyushen. All rights reserved.
//

#import "RegisterViewController.h"
#import <SMS_SDK/SMSSDK.h>
#import "HomeViewController.h"
@interface RegisterViewController ()

@property(nonatomic,strong)UIView *alphView;
@property(nonatomic,strong)CustomTextField *phoneField;
@property(nonatomic,strong)CustomTextField *passwordField;
@property(nonatomic,strong)CustomTextField *authCodeField;
@property(nonatomic,strong)UIButton *codeTimeBtn;
@property(nonatomic,strong)UIButton *registerBtn;
@property(nonatomic,assign)BOOL resetCodeTime;

@end

@implementation RegisterViewController

#pragma mark - private method
- (void) _getVertifySuccess {
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
                
                [self.codeTimeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                self.codeTimeBtn.userInteractionEnabled = YES;
                self.codeTimeBtn.selected = NO;
                
            });
        }else{
            int seconds = timeout % 61;
            NSString *strTime = [NSString stringWithFormat:@"%.1d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (self.resetCodeTime)
                {
                    dispatch_source_cancel(_timer);
                    [self.codeTimeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                    self.codeTimeBtn.userInteractionEnabled = YES;
                    self.codeTimeBtn.selected = NO;
                }
                else
                {
                    self.codeTimeBtn.selected = YES;
                    [self.codeTimeBtn setTitle:[NSString stringWithFormat:@"%@s重新获取",strTime] forState:UIControlStateSelected];
                    [self.codeTimeBtn setTitleColor:RGB(209, 209, 209) forState:UIControlStateSelected];
                    self.codeTimeBtn.userInteractionEnabled = NO;
                    
                }
                
                
            });
            timeout--;
            
        }
    });
    dispatch_resume(_timer);
}

- (void) _getVertifyCode {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:@"17612126606"
                                   zone:@"86"
                       customIdentifier:nil
                                 result:^(NSError *error){
                                     [MBProgressHUD hideHUDForView:self.view animated:YES];
                                     if (!error) {
                                         NSLog(@"获取验证码成功");
                                         [self _getVertifySuccess];


                                     } else {
                                         NSLog(@"错误信息：%@",error);
                                     }}];
}

//http://localhost:8080/user/regist?mobile=15618823540&password=900512&deviceId=111111111111111111111&terminal=20
- (void)_triggerRegister {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [[YWAFHttpManager shareHttpManager] requestPostURL:@"http://112.74.48.30:8080/user/regist"
                                        withParameters:@{@"mobile" : self.phoneField.text, @"password":self.passwordField.text, @"deviceId":@"111111111", @"terminal": @(20)}
                                          withUserInfo:nil
                                      withReqOverBlock:^(YWAFHttpResponse *response) {
                                          [MBProgressHUD hideHUDForView:self.view animated:YES];
                                          
                                          if (response.ret == HTTPRetCodeOK) {
                                              NSDictionary *data = (NSDictionary *)response.data;
                                              [[DataManager shareManager] configUserDict:data[@"user"]];
                                              
                                              HomeViewController *homeCtr = [[HomeViewController alloc] init];
                                              [self.navigationController pushViewController:homeCtr animated:YES];
                                          }                                          
                                      }];
}

#pragma mark -
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
                      withLeftImageName:@"phone_icon-2"];
    [_alphView addSubview:_phoneField];
    _phoneField.text = @"17612126606";
    
    _passwordField = [self createTextField:@"请输入密码"
                         withLeftImageName:@"password_icon-2"];
    [_alphView addSubview:_passwordField];
    _passwordField.text = @"111111";
    
    _authCodeField = [self createTextField:@"请输入验证码"
                         withLeftImageName:@"authcode_icon-2"];
    [_alphView addSubview:_authCodeField];
    
    _codeTimeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_codeTimeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [_codeTimeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _codeTimeBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
    [_codeTimeBtn addTarget:self action:@selector(clickedRightCodeTimeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_alphView addSubview:_codeTimeBtn];
    
    _registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_registerBtn setTitle:@"注册" forState:UIControlStateNormal];
    [_registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _registerBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    _registerBtn.layer.cornerRadius = 4;
    [_registerBtn setBackgroundColor:RGB(93, 94, 105)];
    [_registerBtn addTarget:self action:@selector(clickedRegister:) forControlEvents:UIControlEventTouchUpInside];
    [_alphView addSubview:_registerBtn];
    
    [_phoneField mas_makeConstraints:^(MASConstraintMaker *make){
        
        make.left.mas_offset(20);
        make.right.mas_offset(-20);
        make.top.mas_offset(40);
        make.height.mas_equalTo(40);
    }];
    [_passwordField mas_makeConstraints:^(MASConstraintMaker *make){
        
        make.top.equalTo(_phoneField.mas_bottom).mas_offset(20);
        make.left.equalTo(_phoneField.mas_left);
        make.right.equalTo(_phoneField.mas_right);
        make.height.equalTo(_phoneField.mas_height);
    }];
    [_authCodeField mas_makeConstraints:^(MASConstraintMaker *make){
        
        make.top.equalTo(_passwordField.mas_bottom).mas_offset(20);
        make.left.equalTo(_phoneField.mas_left);
        make.right.equalTo(_codeTimeBtn.mas_left).mas_offset(-10);
        make.height.equalTo(_phoneField.mas_height);
    }];
    [_codeTimeBtn mas_makeConstraints:^(MASConstraintMaker *make){
        
        make.centerY.equalTo(_authCodeField.mas_centerY);
        make.right.equalTo(_phoneField.mas_right);
        make.left.equalTo(_authCodeField.mas_right).mas_offset(10);
        make.width.mas_equalTo(70);
    }];
    
    [_registerBtn mas_makeConstraints:^(MASConstraintMaker *make){
        
        make.centerX.mas_offset(0);
        make.top.equalTo(_authCodeField.mas_bottom).mas_offset(40);
        make.width.mas_equalTo(80);
        make.height.mas_equalTo(40);
    }];
}

- (CustomTextField *)createTextField:(NSString *)placeString withLeftImageName:(NSString *)imaName
{
    UIImage *ima = [UIImage imageNamed:imaName];
    UIImageView *_leftView = [[UIImageView alloc] init];
    [_leftView setImage:ima];
    [_leftView setFrame:CGRectMake(0, 0, 20, 20)];
    CustomTextField *field = [[CustomTextField alloc] initWithOffsetX:8 textInset:40];
    field.placeholder = placeString;
    field.leftView = _leftView;
    field.leftViewMode = UITextFieldViewModeAlways;
    field.font = [UIFont systemFontOfSize:12.0];
    field.delegate = self;
    [field setBackgroundColor:RGB(61, 49, 62)];
    [field setValue:[[UIColor whiteColor] colorWithAlphaComponent:0.5] forKeyPath:@"_placeholderLabel.textColor"];
    field.textColor = [UIColor whiteColor];
    field.borderStyle = UITextBorderStyleNone;
    field.layer.cornerRadius = 20;
    return field;
}

- (void)clickedRegister:(UIButton *)sender
{
    [self _triggerRegister];

//
//    [SMSSDK commitVerificationCode:self.authCodeField.text phoneNumber:self.phoneField.text zone:@"86" result:^(SMSSDKUserInfo *userInfo, NSError *error) {
//        
//        {
//            if (!error)
//            {
//                [self _triggerRegister];
//                NSLog(@"验证成功");
//            }
//            else
//            {
//                NSLog(@"错误信息:%@",error);
//            }
//        }
//    }];
    
    NSLog(@"注册");

}



- (void)clickedRightCodeTimeBtn:(UIButton *)timeBtn
{
    [self _getVertifyCode];
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
