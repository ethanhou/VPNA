//
//  BaseTableViewCell.h
//  VPNA
//
//  Created by Houyushen on 17/2/18.
//  Copyright © 2017年 Houyushen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTableViewCell.h"

@interface BaseTableViewCell : UITableViewCell

@property (nonatomic, assign) NSInteger index;

- (void)initCell;

@end
