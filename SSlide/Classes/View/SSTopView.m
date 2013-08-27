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
    float topMargin = IS_IPAD ? [[SSDB5 theme]floatForKey:@"page_top_margin_ipad"] : [[SSDB5 theme]floatForKey:@"page_top_margin_iphone"];
    self.backgroundColor = [UIColor clearColor];
    
    [self initSlideListView:topMargin];
 
    float width = IS_IPAD ? 100.f * 1.8f : 100.f;
    float height = IS_IPAD ? 31.f * 1.8f : 31.f;

    UIView *titleBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, topMargin)];
    titleBackground.backgroundColor = [[SSDB5 theme] colorForKey:@"app_title_color"];
    UIImageView *titleImage = [[UIImageView alloc] initWithFrame:CGRectMake((self.bounds.size.width - width)/2,
                                                                            (topMargin - height)/2,
                                                                            width,
                                                                            height)];
    titleImage.image = [UIImage imageNamed:@"appname.png"];
    [titleBackground addSubview:titleImage];
    
    [self addSubview:titleBackground];
}

- (void) initSlideListView:(float) topMargin
{
    self.slideListView = [[SSSlideListView alloc] initWithFrame:CGRectMake(0,
                                                                        topMargin,
                                                                        self.bounds.size.width,
                                                                        self.bounds.size.height - topMargin)];
    self.slideListView.delegate = self.delegate;
    [self addSubview:self.slideListView];
}

@end
