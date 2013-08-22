//
//  SSTopView.m
//  SSlide
//
//  Created by iNghia on 8/21/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import "SSTopView.h"
#import "SSSlideCell.h"
#import "SSSlideshow.h"

@interface SSTopView() <UITableViewDataSource, UITableViewDelegate>

@end

@implementation SSTopView
{
    float topMargin;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) initTopTitle
{
    UILabel *topTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, topMargin)];
    topTitle.text = @"SSlide";
    [topTitle setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:topTitle];
}

- (void) initSlideTableView
{
    topMargin = 50.0f;
    self.slideTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                        topMargin,
                                                                        self.bounds.size.width,
                                                                        self.bounds.size.height - topMargin)];
    self.slideTableView.delegate = self;
    self.slideTableView.dataSource = self;
    self.slideTableView.backgroundColor = [UIColor clearColor];
    self.slideTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:self.slideTableView];
}

- (void) initView
{
    self.backgroundColor = [[SSDB5 theme] colorForKey:@"top_view_bg_color"];
    [self initSlideTableView];
    [self initTopTitle];
}

#pragma mark - tableview delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.delegate numberOfRow];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"SlideCell";
    SSSlideCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[SSSlideCell alloc] init];
        //cell.frame = CGRectMake(0, 0, self.bounds.size.width, 110);
    }
    
    SSSlideshow *data = [self.delegate getDataAtIndex:indexPath.row];
    [cell setData:data];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (IS_IPAD) {
        return 250;
    }
    return 110;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    
    NSInteger currentOffset = scrollView.contentOffset.y;
    NSInteger maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height;
    
    if (maximumOffset - currentOffset <= -40) {
        [self.delegate getMoreSlides];
    }
}

@end
