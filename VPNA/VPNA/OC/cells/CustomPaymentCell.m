//
//  CustomPaymentCell.m
//  VPNA
//
//  Created by Houyushen on 17/2/18.
//  Copyright © 2017年 Houyushen. All rights reserved.
//

#import "CustomPaymentCell.h"

@implementation CustomPaymentCell

- (void)initCell {
    _label1 = [[UILabel alloc] init];
    [_label1 setBackgroundColor:[UIColor clearColor]];
    [_label1 setFont:[UIFont systemFontOfSize:14.0]];
    [_label1 setText:@"自定义 "];
    _label1.textAlignment = NSTextAlignmentCenter;
    [_label1 setTextColor:[UIColor whiteColor]];
    [self.contentView addSubview:_label1];
    
    _label2 = [[UILabel alloc] init];
    [_label2 setBackgroundColor:[UIColor clearColor]];
    [_label2 setFont:[UIFont systemFontOfSize:14.0]];
    [_label2 setText:@" 天 X 1元＝"];
    _label2.textAlignment = NSTextAlignmentCenter;
    [_label2 setTextColor:[UIColor whiteColor]];
    [self.contentView addSubview:_label2];
    
    _label3 = [[UILabel alloc] init];
    [_label3 setBackgroundColor:[UIColor clearColor]];
    [_label3 setFont:[UIFont systemFontOfSize:14.0]];
    [_label3 setText:@"元"];
    _label3.textAlignment = NSTextAlignmentCenter;
    [_label3 setTextColor:[UIColor whiteColor]];
    [self.contentView addSubview:_label3];
    
    _dayField = [[UITextField alloc] init];
    _dayField.backgroundColor = [UIColor whiteColor];
    _dayField.borderStyle = UITextBorderStyleNone;
    _dayField.textAlignment = NSTextAlignmentCenter;
    _dayField.keyboardType = UIKeyboardTypeNumberPad;
    _dayField.delegate = self;
    [self.contentView addSubview:_dayField];
    
    _amountLabel = [[UILabel alloc] init];
    [_amountLabel setBackgroundColor:[UIColor whiteColor]];
    [_amountLabel setFont:[UIFont systemFontOfSize:14.0]];
    _amountLabel.textAlignment = NSTextAlignmentCenter;
    [_amountLabel setTextColor:[UIColor blackColor]];
    [self.contentView addSubview:_amountLabel];
    
    _payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_payBtn setImage:[UIImage imageNamed:@"pay_icon"] forState:UIControlStateNormal];
    [_payBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _payBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    _payBtn.layer.cornerRadius = 4;
    [_payBtn addTarget:self action:@selector(payBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_payBtn];
    
    [_label1 mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.mas_greaterThanOrEqualTo(10);
        make.height.mas_equalTo(30);
        make.centerY.mas_offset(0);
    }];
    
    [_dayField mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(_label1.mas_right).mas_offset(1);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(40);
        make.centerY.mas_offset(0);
    }];
    
    [_label2 mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(_dayField.mas_right).mas_offset(1);
        make.height.mas_equalTo(30);
        make.centerY.mas_offset(0);
    }];
    
    [_amountLabel mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(_label2.mas_right).mas_offset(1);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(50);
        make.centerY.mas_offset(0);
    }];
    
    [_label3 mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(_amountLabel.mas_right).mas_offset(2);
        make.height.mas_equalTo(30);
        make.centerY.mas_offset(0);
    }];
    
    [_payBtn mas_makeConstraints:^(MASConstraintMaker *make){
        make.left.equalTo(_label3.mas_right).mas_offset(2);
        make.centerY.mas_offset(0);
        make.width.height.mas_equalTo(30);
    }];
    
}

- (void)payBtnClicked:(UIButton *)payBtn {
    if (self.didClickBlock) {
        self.didClickBlock();
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSInteger existedLength = textField.text.length;
    NSInteger selectedLength = range.length;
    NSInteger replaceLength = string.length;
    if (existedLength - selectedLength + replaceLength > 3)
    {
        return NO;
    }
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"te:%@",textField.text);
    _amountLabel.text = textField.text;
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
