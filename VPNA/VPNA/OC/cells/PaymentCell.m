//
//  PaymentCell.m
//  VPNA
//
//  Created by Houyushen on 17/2/17.
//  Copyright © 2017年 Houyushen. All rights reserved.
//

#import "PaymentCell.h"

@implementation PaymentCell



- (void)initCell {
    _payInfoLabel = [[UILabel alloc] init];
    [_payInfoLabel setBackgroundColor:[UIColor clearColor]];
    [_payInfoLabel setFont:[UIFont systemFontOfSize:16.0]];
    _payInfoLabel.textAlignment = NSTextAlignmentLeft;
    [_payInfoLabel setTextColor:[UIColor whiteColor]];
    [self.contentView addSubview:_payInfoLabel];
    
    _payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_payBtn setImage:[UIImage imageNamed:@"pay_icon"] forState:UIControlStateNormal];
    [_payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _payBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    _payBtn.layer.cornerRadius = 4;
    [_payBtn addTarget:self action:@selector(payBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_payBtn];
    
    [_payInfoLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_offset(20);
        make.height.mas_offset(30);
        make.width.mas_equalTo(150);
        make.centerY.mas_offset(0);
    }];
    
    [_payBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.centerY.mas_offset(0);
        make.left.equalTo(_payInfoLabel.mas_right).mas_offset(5);
        make.height.mas_equalTo(40.f);
        make.width.mas_equalTo(45);
    }];
}

- (void)payBtnClicked:(UIButton *)payBtn {
    if (self.didClickBlock) {
        self.didClickBlock();
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
