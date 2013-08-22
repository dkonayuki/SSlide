//
//  SSTopView.m
//  SSlide
//
//  Created by iNghia on 8/21/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import "SSTopView.h"
#import "SSSlideTableView.h"
#import "SSSlideCell.h"

@interface SSTopView() <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) SSSlideTableView *slideTableView;

@end

@implementation SSTopView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) initView
{
    self.backgroundColor = [[SSDB5 theme] colorForKey:@"top_view_bg_color"];
    float topMargin = 50.f;
    self.slideTableView = [[SSSlideTableView alloc] initWithFrame:CGRectMake(0,
                                                                             topMargin,
                                                                             self.bounds.size.width,
                                                                             self.bounds.size.height - topMargin)];
    self.slideTableView.delegate = self;
    self.slideTableView.dataSource = self;
    self.slideTableView.backgroundColor = [UIColor clearColor];
    self.slideTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:self.slideTableView];
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
    }
    
    NSDictionary *data = [self.delegate getDataAtIndex:indexPath.row];
    [cell setDataWithDictionary:data];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110;
}

@end
