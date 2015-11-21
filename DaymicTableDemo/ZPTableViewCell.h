//
//  ZPTableViewCell.h
//  DaymicTableDemo
//
//  Created by 陈浩 on 15/11/20.
//  Copyright © 2015年 陈浩. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZPLabel.h"

@interface ZPTableViewCell : UITableViewCell

@property (nonatomic, strong) ZPLabel *titleLabel;
@property (nonatomic, strong) ZPLabel *subtitleLabel;
@property (nonatomic, strong) UIImageView *customImageView;

@end
