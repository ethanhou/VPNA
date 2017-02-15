//
//  PayViewController.m
//  VPNA
//
//  Created by 龙章辉 on 2017/2/15.
//  Copyright © 2017年 Houyushen. All rights reserved.
//

#import "PayViewController.h"

@interface PayViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *_dataArray;
}
@property(nonatomic,strong)UITableView *tableView;
@end

@implementation PayViewController

- (void)viewDidLoad {
    [super viewDidLoad];

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
    return 60;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identi = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identi];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identi];
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
