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
    float width = 100.f;
    float height = 31.f;
    if (IS_IPAD)
    {
        fontSize *= 2.2;
        width *= 2.2;
        height *= 2.2;
    }
    UIImageView *titleBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.topMargin)];
    titleBackground.backgroundColor = [[SSDB5 theme] colorForKey:@"app_title_color"];
    UIImage *title = [UIImage imageNamed: @"appname.png"];
    
    UIImageView *titleView = [[UIImageView alloc] initWithFrame:CGRectMake(
                    (self.bounds.size.width - width)/2,
                    (self.topMargin - height)/2, width, height)];
    [titleView setImage:title];
    [self addSubview:titleBackground];
    [self addSubview:titleView];
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
    self.backgroundColor = [UIColor clearColor];
    [self initSlideListView];
    [self initTopTitle];
}

@end
