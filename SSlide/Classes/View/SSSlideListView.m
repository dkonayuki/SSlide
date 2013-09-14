//
//  SSSlideListView.m
//  SSlide
//
//  Created by techcamp on 2013/08/23.
//  Copyright (c) 2013年 S2. All rights reserved.
//

#import "SSSlideListView.h"
#import "SSSlideCell.h"

@interface SSSlideListView() <UITableViewDataSource, UITableViewDelegate>

@end

@implementation SSSlideListView

- (void) initView
{
    self.infiniteLoad = YES;
    self.slideTableView = [[UITableView alloc] initWithFrame:self.bounds];
    self.slideTableView.delegate = self;
    self.slideTableView.dataSource = self;
    self.slideTableView.backgroundColor = [UIColor clearColor];
    self.slideTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:self.slideTableView];
}

#pragma mark - tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.delegate numberOfRows];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"SlideCell";
    SSSlideCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[SSSlideCell alloc] init];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    SSSlideshow *data = [self.delegate getDataAtIndex:indexPath.row];
    [cell setData:data];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (IS_IPAD)
    {
        return [[SSDB5 theme] floatForKey:@"slide_cell_height_ipad"];
    }
    return [[SSDB5 theme] floatForKey:@"slide_cell_height_iphone"];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!self.infiniteLoad) {
        return;
    }
    
    NSInteger currentOffset = scrollView.contentOffset.y;
    NSInteger maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    NSInteger diffOffset = 400;
    if (IS_IPAD) {
        diffOffset *= 2.2;
    }
    
    static BOOL sLoading = NO;
    
    if (maximumOffset - currentOffset <= diffOffset)
    {
        UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [spinner startAnimating];
        spinner.frame = CGRectMake(0, 0, self.bounds.size.width, 44);
        self.slideTableView.tableFooterView = spinner;
        if (!sLoading) {
            sLoading = YES;
            [self.delegate getMoreSlides:^(void) {
                self.slideTableView.tableFooterView = nil;
                sLoading = NO;
            }];
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate didSelectedAtIndex:indexPath.row];
}

#pragma mark
- (void)reloadRowsWithAnimation
{
    NSIndexSet *section = [[NSIndexSet alloc] initWithIndex:0];
    [self.slideTableView reloadSections:section withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)addRowsWithAnimation:(NSUInteger)from andSum:(NSUInteger)sum
{
    if (sum <= 0) {
        return;
    }
    NSMutableArray *pathArray = [[NSMutableArray alloc] init];
    for (int i = from; i < from + sum; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        [pathArray addObject:indexPath];
    }
    [self.slideTableView insertRowsAtIndexPaths:pathArray withRowAnimation:UITableViewRowAnimationAutomatic];
}

@end
