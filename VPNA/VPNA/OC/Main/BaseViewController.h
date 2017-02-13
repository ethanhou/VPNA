//
//  BaseViewController.h
//  VPNA
//
//  Created by 龙章辉 on 2017/2/13.
//  Copyright © 2017年 Houyushen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry.h>

@interface CustomTextField : UITextField
{
    float offsetX;
    float inset;
}
- (instancetype)initWithOffsetX:(float)_offsetX textInset:(float)_inset;
@end

@interface BaseViewController : UIViewController

@property(nonatomic,strong)UIImageView *bgView;
@property(nonatomic,strong)UIImageView *logoView;

- (void)onBackButtonItemAction:(UIButton *)sender;
- (void)setLeftBarButtonWithImageName:(NSString *)imaName;
- (void)setLeftBarButtonWithButton:(UIButton *)button;
@end
