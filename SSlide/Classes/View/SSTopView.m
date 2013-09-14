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

@end

@implementation SSTopView

- (void) initView
{
    self.backgroundColor = [UIColor clearColor];
    
    float topBarHeight = IS_IPAD ? [[SSDB5 theme]floatForKey:@"page_top_margin_ipad"] : [[SSDB5 theme]floatForKey:@"page_top_margin_iphone"];
    float statusBarHeight = SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0") ? 20.f : 0.f;
    float topMargin = topBarHeight + statusBarHeight;
    
    float width = IS_IPAD ? 100.f * 1.8f : 100.f;
    float height = IS_IPAD ? 31.f * 1.8f : 31.f;
    
    UIColor *bgColor = [UIColor clearColor];//SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0") ? [UIColor clearColor] : [[SSDB5 theme] colorForKey:@"app_title_color"];
    UIView *titleBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, topMargin)];
    titleBackground.backgroundColor = bgColor;
    
    UIImageView *titleImage = [[UIImageView alloc] initWithFrame:CGRectMake((self.bounds.size.width - width)/2,
                                                                            statusBarHeight + (topBarHeight - height)/2,
                                                                            width,
                                                                            height)];
    titleImage.image = [UIImage imageNamed:@"appname.png"];
    [titleBackground addSubview:titleImage];
    [self addSubview:titleBackground];
    
    // slide list view
    [self initSlideListView:topMargin];
}

- (void) initSlideListView:(float) topMargin
{
    self.slideListView = [[SSSlideListView alloc] initWithFrame:CGRectMake(0,
                                                                           topMargin,
                                                                           self.bounds.size.width,
                                                                           self.bounds.size.height - topMargin)
                                                    andDelegate:self.delegate];
    [self addSubview:self.slideListView];
}

@end
