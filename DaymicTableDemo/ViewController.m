//
//  ViewController.m
//  DaymicTableDemo
//
//  Created by 陈浩 on 15/11/19.
//  Copyright © 2015年 陈浩. All rights reserved.
//

#import "ViewController.h"
#import "ZPTableViewCell.h"
#import "UIImageView+WebCache.h"

static NSString *CellTableIdentifier = @"CellTableIdentifier";

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *data;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self initData];
        [self reloadTableViewContent];
    });
    
}

- (void)initData {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"item" ofType:@"json"];
    NSData *fileData = [[NSData alloc] initWithContentsOfFile:filePath];
    
    NSError* error;
    self.data = [NSJSONSerialization JSONObjectWithData:fileData
                                                         options:kNilOptions
                                                           error:&error];
}

- (void)reloadTableViewContent {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
    });
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 141;
    }
    return _tableView;
}

#pragma mark - private method
- (void)setTitleForCell:(ZPTableViewCell *)cell item:(NSDictionary *)item {
    NSString *title = item[@"title"];
    [cell.titleLabel setText:title];
    [cell.titleLabel invalidateIntrinsicContentSize];
}

- (void)setSubtitleForCell:(ZPTableViewCell *)cell item:(NSDictionary *)item {
    NSString *subtitle = item[@"context"];
    
    if (subtitle.length > 200) {
        subtitle = [NSString stringWithFormat:@"%@...", [subtitle substringToIndex:200]];
    }
    
    [cell.subtitleLabel setText:subtitle];
    [cell.subtitleLabel invalidateIntrinsicContentSize];
}

- (void)setImageForCell:(ZPTableViewCell *)cell item:(NSDictionary *)item {
    NSString *preview_url = item[@"preview_url"];
    [cell.customImageView sd_setImageWithURL:[NSURL URLWithString:preview_url]];
}

- (void)configureImageCell:(ZPTableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *item = self.data[indexPath.row];
    [self setTitleForCell:cell item:item];
    [self setSubtitleForCell:cell item:item];
    [self setImageForCell:(id)cell item:item];
}

- (ZPTableViewCell *)galleryCellAtIndexPath:(NSIndexPath *)indexPath {
    ZPTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    if (!cell) {
        cell = [[ZPTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellTableIdentifier];
    }
    [self configureImageCell:cell atIndexPath:indexPath];
    return cell;
}

- (CGFloat)heightForImageCellAtIndexPath:(NSIndexPath *)indexPath {
    static ZPTableViewCell *sizingCell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sizingCell = [self.tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
        if (!sizingCell) {
            sizingCell = [[ZPTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellTableIdentifier];
        }
    });
    
    [self configureImageCell:sizingCell atIndexPath:indexPath];
    return [self calculateHeightForConfiguredSizingCell:sizingCell];
}

- (CGFloat)calculateHeightForConfiguredSizingCell:(UITableViewCell *)sizingCell {
    
    sizingCell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.tableView.frame), CGRectGetHeight(sizingCell.bounds));
    
    [sizingCell setNeedsLayout];
    [sizingCell layoutIfNeeded];
    
    //Request the cell to lay out its content by calling setNeedsLayout and layoutIfNeeded. Ask auto layout to calculate the systemLayoutSizeFittingSize:, passing in the parameter UILayoutFittingCompressedSize, and that means “use the smallest possible size” that fits the auto layout constraints.Return the calculated height plus one to account for the cell separator’s height.
    
    CGSize size = [sizingCell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    
    return size.height + 1.0f; // Add 1.0f for the cell separator height
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self galleryCellAtIndexPath:indexPath];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self heightForImageCellAtIndexPath:indexPath];
}

@end
