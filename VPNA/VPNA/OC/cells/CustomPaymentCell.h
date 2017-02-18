//
//  CustomPaymentCell.h
//  VPNA
//
//  Created by Houyushen on 17/2/18.
//  Copyright © 2017年 Houyushen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"

@interface CustomPaymentCell : BaseTableViewCell

@property (nonatomic, strong) UILabel *label1;
@property (nonatomic, strong) UILabel *label2;
@property (nonatomic, strong) UILabel *label3;

@property (nonatomic, strong) UITextField *dayField;
@property (nonatomic, strong) UILabel *amountLabel;
@property (nonatomic, strong) UIButton *payBtn;
@property (nonatomic, copy) void (^didClickBlock)();

@end
