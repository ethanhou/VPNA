//
//  LoginViewController.m
//  VPNA
//
//  Created by 龙章辉 on 2017/2/13.
//  Copyright © 2017年 Houyushen. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "ResetPwdViewController.h"
#import "HomeViewController.h"

@interface LoginViewController ()

@property(nonatomic,strong)UIView *alphView;
@property(nonatomic,strong)CustomTextField *phoneField;
@property(nonatomic,strong)CustomTextField *passwordField;
@property(nonatomic,strong)UIButton *loginBtn;
@property(nonatomic,strong)UIButton *registerBtn;
@property(nonatomic,strong)UIButton *forgetBtn;

@end

@implementation LoginViewController

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
    _phoneField.text = @"17612126606";
    
    UIView *lineView = [[UIView alloc] init];
    [lineView setBackgroundColor:RGB(235, 236, 238)];
    [_alphView addSubview:lineView];
    
    _passwordField = [self createTextField:@"请输入密码"
                         withLeftImageName:@"password_icon-1"];
    [_alphView addSubview:_passwordField];
    _passwordField.text = @"111111";

    
    _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_loginBtn setBackgroundColor:RGBA(91, 91, 112,0.6)];
    [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [_loginBtn.titleLabel setFont:[UIFont systemFontOfSize:18.0]];
    [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _loginBtn.layer.cornerRadius = 6;
    [_loginBtn addTarget:self action:@selector(clickedLogin:) forControlEvents:UIControlEventTouchUpInside];
    [_alphView addSubview:_loginBtn];
    
    
    _registerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_registerBtn setBackgroundColor:[UIColor clearColor]];
    [_registerBtn setTitle:@"我要注册" forState:UIControlStateNormal];
    [_registerBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [_registerBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_registerBtn addTarget:self action:@selector(clickedRegister:) forControlEvents:UIControlEventTouchUpInside];
    [_alphView addSubview:_registerBtn];
    
    UIView *spaceView = [[UIView alloc] init];
    [spaceView setBackgroundColor:[UIColor whiteColor]];
    [_alphView addSubview:spaceView];
    
    _forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_forgetBtn setBackgroundColor:[UIColor clearColor]];
    [_forgetBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    [_forgetBtn.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [_forgetBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_forgetBtn addTarget:self action:@selector(clickedForget:) forControlEvents:UIControlEventTouchUpInside];
    [_alphView addSubview:_forgetBtn];

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
    [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make){
        
        make.top.equalTo(_passwordField.mas_bottom).mas_offset(20);
        make.left.equalTo(_phoneField.mas_left);
        make.right.equalTo(_phoneField.mas_right);
        make.height.mas_equalTo(40);
    }];
    
    [spaceView mas_makeConstraints:^(MASConstraintMaker *make){
        
        make.top.equalTo(_loginBtn.mas_bottom).mas_offset(30);
        make.centerX.mas_offset(0);
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(13);
    }];
    
    [_registerBtn mas_makeConstraints:^(MASConstraintMaker *make){
        
        make.centerY.equalTo(spaceView.mas_centerY);
        make.right.equalTo(spaceView.mas_left).mas_offset(-15);
    }];
    [_forgetBtn mas_makeConstraints:^(MASConstraintMaker *make){
        
        make.centerY.equalTo(spaceView.mas_centerY);
        make.left.equalTo(spaceView.mas_left).mas_offset(15);
    }];
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
    field.font = [UIFont systemFontOfSize:13.0];
    field.delegate = self;
    field.textColor = [UIColor grayColor];
    field.borderStyle = UITextBorderStyleNone;
    [field setBackgroundColor:[UIColor whiteColor]];
    return field;
}

- (void)clickedLogin:(UIButton *)sender
{
    NSLog(@"登录");
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

    [[YWAFHttpManager shareHttpManager] requestPostURL:@"http://112.74.48.30:8080/user/login"
                                        withParameters:@{@"mobile" : self.phoneField.text, @"password":self.passwordField.text}
                                          withUserInfo:nil
                                      withReqOverBlock:^(YWAFHttpResponse *response) {
                                          [MBProgressHUD hideHUDForView:self.view animated:YES];
                                          HomeViewController *homeCtr = [[HomeViewController alloc] init];
                                          [self.navigationController pushViewController:homeCtr animated:YES];
                                          NSLog(@"成功");
                                      }];
}
- (void)clickedRegister:(UIButton *)sender
{
    NSLog(@"注册");
    RegisterViewController *registerCtr = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:registerCtr animated:YES];
}
- (void)clickedForget:(UIButton *)sender
{
    NSLog(@"忘记密码");
    ResetPwdViewController *resetPwdCtr = [[ResetPwdViewController alloc] init];
    [self.navigationController pushViewController:resetPwdCtr animated:YES];
}
- (void)onBackButtonItemAction:(UIButton *)sender
{
    NSLog(@"返回");
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


