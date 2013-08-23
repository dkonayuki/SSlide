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

@interface SSTopView()

@property (nonatomic) float topMargin;

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

- (void) initTopTitle
{
    float fontSize = 14;
    if (IS_IPAD)
    {
        fontSize *= 2.2;
    }
    UILabel *topTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.topMargin)];
    topTitle.text = @"SSlide";
    topTitle.font = [UIFont systemFontOfSize:fontSize];
    [topTitle setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:topTitle];
}

- (void) initSlideListView
{
    self.slideListView = [[SSSlideListView alloc] initWithFrame:CGRectMake(0,
                                                                        self.topMargin,
                                                                        self.bounds.size.width,
                                                                        self.bounds.size.height - self.topMargin)];
    self.slideListView.delegate = self.delegate;
    [self addSubview:self.slideListView];
}

- (void) initView
{
    self.topMargin = [[SSDB5 theme]floatForKey:@"page_top_margin"];
    if (IS_IPAD)
    {
        self.topMargin *= 2.2;
    }
    self.backgroundColor = [[SSDB5 theme] colorForKey:@"top_view_bg_color"];
    [self initSlideListView];
    [self initTopTitle];
}

@end
