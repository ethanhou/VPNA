//
//  PaymentCell.h
//  VPNA
//
//  Created by Houyushen on 17/2/17.
//  Copyright © 2017年 Houyushen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"

@interface PaymentCell : BaseTableViewCell

@property (nonatomic, strong) UILabel *payInfoLabel;
@property (nonatomic, strong) UIButton *payBtn;
@property (nonatomic, copy) void (^didClickBlock)();
@end
