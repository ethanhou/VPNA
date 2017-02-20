//
//  PayViewController.m
//  VPNA
//
//  Created by 龙章辉 on 2017/2/15.
//  Copyright © 2017年 Houyushen. All rights reserved.
//

#import "PayViewController.h"
#import "PaymentCell.h"
#import "CustomPaymentCell.h"
#import <AlipaySDK/AlipaySDK.h>

@interface PayViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *_dataArray;
}
@property(nonatomic,strong)UITableView *tableView;
@property (nonatomic, strong) UIButton *nextBtn;
@property (nonatomic, strong) CustomPaymentCell *customPaymentCell;

@end

@implementation PayViewController

- (void)initCustomPaymentCell {
    self.customPaymentCell = [[CustomPaymentCell alloc] initWithStyle:UITableViewCellStyleValue1
                                                      reuseIdentifier:nil];
}

- (void)requestAllService {
    [[YWAFHttpManager shareHttpManager] requestPostURL:@"http://112.74.48.30:8080/service/allService"
                                        withParameters:nil
                                          withUserInfo:nil
                                      withReqOverBlock:^(YWAFHttpResponse *response) {
                                          [MBProgressHUD hideHUDForView:self.view animated:YES];

                                          if (response.ret == HTTPRetCodeOK) {
                                              NSDictionary *dict = (NSDictionary *)response.data;
                                              
                                          }
                                      }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self requestAllService];
    
    [self initCustomPaymentCell];

    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    
    _dataArray = [NSMutableArray arrayWithObjects:@{@"month":@(1),@"price":@(29)},
                  @{@"month":@(1),@"price":@(29)},
                  @{@"month":@(1),@"price":@(29)},
                  @{@"month":@(1),@"price":@(29)},nil];
    _tableView = [[UITableView alloc] init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.tableFooterView = [UIView new];
    [_tableView setBackgroundColor:RGBA(50, 47, 76,0.5)];
    _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    _tableView.tableHeaderView = header;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make){
        
        make.left.mas_offset(20);
        make.right.mas_offset(-20);
        make.height.mas_equalTo(360);
        make.top.equalTo(self.logoView.mas_bottom).mas_offset(40);

    }];
}


#pragma mark UITableViewDelegate & UITableViewDataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if (indexPath.row == _dataArray.count) {
        self.customPaymentCell.index = indexPath.row;
        cell = self.customPaymentCell;
    } else {
        static NSString *identi = @"Cell";
        cell = [tableView dequeueReusableCellWithIdentifier:identi];
        if (!cell) {
            
            cell = [[PaymentCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identi];
        }
        PaymentCell *payCell = (PaymentCell *)cell;
        payCell.index = indexPath.row;
        payCell.didClickBlock = ^(NSInteger index) {
            
        };

    }
    [cell setBackgroundColor:[UIColor clearColor]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
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
