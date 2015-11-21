//
//  ZPTableViewCell.m
//  DaymicTableDemo
//
//  Created by 陈浩 on 15/11/20.
//  Copyright © 2015年 陈浩. All rights reserved.
//

#import "ZPTableViewCell.h"
#import "Masonry.h"

@implementation ZPTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self.contentView addSubview:self.customImageView];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.subtitleLabel];
        [self autoLayout];
    }
    return self;
}

- (ZPLabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[ZPLabel alloc] init];
        _titleLabel.frame = CGRectMake(128, 20, CGRectGetWidth([UIScreen mainScreen].bounds) - 148, 21);
        _titleLabel.preferredMaxLayoutWidth = 280;
        
    }
    return _titleLabel;
}

- (ZPLabel *)subtitleLabel {
    if (!_subtitleLabel) {
        _subtitleLabel = [[ZPLabel alloc] init];
        _subtitleLabel.frame = CGRectMake(128, 41, CGRectGetWidth([UIScreen mainScreen].bounds) - 148, 21);
        
        _subtitleLabel.preferredMaxLayoutWidth = 280;
        _subtitleLabel.font = [UIFont systemFontOfSize:15];
        _subtitleLabel.textColor = [UIColor lightGrayColor];
        _subtitleLabel.numberOfLines = 0;
        
    }
    return _subtitleLabel;
}

- (UIImageView *)customImageView {
    if (!_customImageView) {
        _customImageView = [[UIImageView alloc] initWithFrame:(CGRect){20,20,100,100}];
    }
    return _customImageView;
}

- (void)autoLayout {
    // customImageView constraint
    [self.customImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).with.offset(20);
        make.bottom.lessThanOrEqualTo(self.contentView.mas_bottom).with.offset(-20);
        make.leading.equalTo(self.contentView.mas_leading).with.offset(20);
        make.width.equalTo(@100).with.priority(999);
        make.height.equalTo(@100).with.priority(999);
    }];
    
    // titleLabel constraint
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).with.offset(20);
        make.trailing.equalTo(self.contentView.mas_trailing).with.offset(-20);
        make.leading.equalTo(self.customImageView.mas_trailing).with.offset(8);
    }];

    // subtitleLabel constraint
    UIEdgeInsets subTitlePadding = UIEdgeInsetsMake(0, 8, -20, -20);
    
    [self.subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(subTitlePadding.top);
        make.trailing.equalTo(self.contentView.mas_trailing).with.offset(subTitlePadding.right);
        make.bottom.lessThanOrEqualTo(self.contentView.mas_bottom).with.offset(subTitlePadding.bottom);
        make.leading.equalTo(self.customImageView.mas_trailing).with.offset(subTitlePadding.left);
    }];
    
}

@end
