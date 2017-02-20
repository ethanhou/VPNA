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
#import "PayModel.h"
#import "PayService.h"
#import "DataManager.h"

@interface PayViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *_dataArray;
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
                                              
                                              
                                              PayModel *model = [[PayModel alloc] initWithDictionary:DictionaryValue(response.data)];
                                              NSMutableArray *tmpData = [NSMutableArray arrayWithArray:model.service];
                                              for (int i=0; i<model.service.count; i++) {
                                                  
                                                  PayService *_service = model.service[i];
                                                  if (_service.serviceType == 1) {
                                                      
                                                      [tmpData removeObject:_service];
                                                  }
                                              }
                                              _dataArray = [NSArray arrayWithArray:tmpData];
                                              [self.tableView reloadData];
                                          }
                                      }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self requestAllService];
    
    [self initCustomPaymentCell];

    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    
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
    return _dataArray.count+1;
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
        PayService *model = _dataArray[indexPath.row];
        NSString *text = [NSString stringWithFormat:@"%@ = %@元",model.serviceName,model.price];
        [payCell.payInfoLabel setText:text];
        WS(weakself);
        payCell.didClickBlock = ^(NSInteger index) {
            
            [weakself createPayOrder:model.payServiceIdentifier];
        };

    }
    [cell setBackgroundColor:[UIColor clearColor]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
}

- (void)createPayOrder:(NSString *)_serviceID
{
    
    WS(weakself);
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:StringValue(_serviceID) forKey:@"serviceId"];
    [params setObject:StringValue([DataManager shareManager].userId) forKey:@"userId"];
    [params setObject:StringValue([DataManager shareManager].deviceId) forKey:@"deviceId"];
    [[YWAFHttpManager shareHttpManager] requestPostURL:@"http://112.74.48.30:8080/order/newOrder"
                                        withParameters:params
                                          withUserInfo:nil
                                      withReqOverBlock:^(YWAFHttpResponse *response) {
                                          [MBProgressHUD hideHUDForView:self.view animated:YES];
                                          
                                          if (response.ret == HTTPRetCodeOK) {
                                              
                                              NSDictionary *dict = DictionaryValue(response.data);
                                              NSDictionary *_order = DictionaryValue(dict[@"VpOrder"]);
                                              [weakself gotoPay:_order[@"id"]];
                                              NSLog(@"response:%@",response.data);
                                              
                                          }
                                      }];
}

- (void)gotoPay:(NSString *)orderId
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:StringValue(orderId) forKey:@"orderId"];
    [[YWAFHttpManager shareHttpManager] requestPostURL:@"http://112.74.48.30:8080/order/payOrder"
                                        withParameters:params
                                          withUserInfo:nil
                                      withReqOverBlock:^(YWAFHttpResponse *response) {
                                          [MBProgressHUD hideHUDForView:self.view animated:YES];
                                          
                                          if (response.ret == HTTPRetCodeOK) {
                                              
                                              NSLog(@"response:%@",response.data);
                                              
                                          }
                                      }];
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
