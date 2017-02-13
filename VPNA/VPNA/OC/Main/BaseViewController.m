//
//  BaseViewController.m
//  VPNA
//
//  Created by 龙章辉 on 2017/2/13.
//  Copyright © 2017年 Houyushen. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
    {
        self.edgesForExtendedLayout = UIRectEdgeTop;
    }
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    _bgView = [[UIImageView alloc] initWithFrame:self.view.frame];
    [_bgView setImage:[UIImage imageNamed:@"bg-1"]];
    [self.view addSubview:_bgView];
    _logoView = [[UIImageView alloc] init];
    [_logoView setImage:[UIImage imageNamed:@"logo"]];
    [self.view addSubview:_logoView];
    [_logoView mas_makeConstraints:^(MASConstraintMaker *make){
        
        make.top.mas_offset(84);
        make.centerX.mas_offset(0);
        make.width.mas_equalTo(43);
        make.height.mas_equalTo(35);
    }];
    [self setBaseNavigationClearStyle];
    [self setLeftBarButtonWithImageName:@"back"];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
    [self.view addGestureRecognizer:tap];
}
- (void)tap
{
    [self.view endEditing:YES];
}

- (void)setBaseNavigationClearStyle
{
    UIColor *bgColor = [UIColor clearColor];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.backgroundColor= bgColor;
    self.navigationController.navigationBar.barTintColor = bgColor;
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
}

- (void)setLeftBarButtonWithImageName:(NSString *)imaName
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 50, 30);
    [backBtn setImage:[UIImage imageNamed:imaName] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(onBackButtonItemAction:) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setBackgroundColor:[UIColor clearColor]];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 30)];
    [self setLeftBarButtonWithButton:backBtn];
}

- (void)setLeftBarButtonWithButton:(UIButton *)button
{
    if (button==nil)
    {
        self.navigationItem.hidesBackButton = YES;
    }
    [button addTarget:self action:@selector(onBackButtonItemAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSeperator.width = -5;
        if (item)
        {
            [self.navigationItem setLeftBarButtonItems:@[negativeSeperator,item]];
        }
        else
        {
            [self.navigationItem setLeftBarButtonItems:@[negativeSeperator]];
        }
    }
    else
    {
        [self.navigationItem setLeftBarButtonItem:item animated:NO];
    }
}

- (void)onBackButtonItemAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIImage *)imageFromColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
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


@implementation CustomTextField

- (instancetype)initWithOffsetX:(float)_offsetX textInset:(float)_inset
{
    if (self == [super init]) {
        
        offsetX = _offsetX;
        inset = _inset;
    }
    return self;
}

- (CGRect)leftViewRectForBounds:(CGRect)bounds
{
    offsetX = offsetX==0?8:offsetX;
    CGRect iconRect = [super leftViewRectForBounds:bounds];
    iconRect.origin.x += offsetX;
    return iconRect;
}

//UITextField 文字与输入框的距离
- (CGRect)textRectForBounds:(CGRect)bounds{
    
    inset = inset==0?35:inset;
    return CGRectInset(bounds, inset, 0);
    
}

//控制文本的位置
- (CGRect)editingRectForBounds:(CGRect)bounds{
    
    inset = inset==0?35:inset;
    return CGRectInset(bounds, inset, 0);
}
@end
