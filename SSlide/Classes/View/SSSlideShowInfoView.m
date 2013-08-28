//
//  SSSlideShowInfoView.m
//  SSlide
//
//  Created by techcamp on 2013/08/28.
//  Copyright (c) 2013年 S2. All rights reserved.
//

#import "SSSlideShowInfoView.h"
#import <QuartzCore/QuartzCore.h>

@interface SSSlideShowInfoView()

@property (strong, nonatomic) UILabel *slideTitle;
@property (strong, nonatomic) UILabel *pageNumberLabel;
@property (strong, nonatomic) UIView *infoBG;
@property (assign, nonatomic) NSString *title;
@property (assign, nonatomic) NSInteger totalPagesNumber;

@end

@implementation SSSlideShowInfoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andTitle:(NSString *)title andTotalPages:(NSInteger)total
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.title = title;
        self.totalPagesNumber = total;
        [self initView];
    }
    return self;
}

- (void)initView
{
    float leftMargin = 5.f;
    float topMargin = 5.f;
    float width = 100.f;
    float height = 40.f;
    float pageWidth = 80.f;
    
    if (IS_IPAD)
    {
        leftMargin *= 2.2;
        topMargin *= 2.2;
        pageWidth *= 2.2;
        height *= 2.2;
    }
    //title
    float titleFontSize = 16.f;
    self.slideTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    self.slideTitle.text = self.title;
    self.slideTitle.backgroundColor = [UIColor clearColor];
    self.slideTitle.font = [UIFont fontWithName:[[SSDB5 theme] stringForKey:@"quicksand_font"] size:titleFontSize];
    [self.slideTitle sizeToFit];
    
    width = self.slideTitle.frame.size.width + leftMargin + pageWidth;
    //number background
    UIView *pageNumberBG =[[UIView alloc] initWithFrame:CGRectMake(width - pageWidth, 0, pageWidth, height)];
    pageNumberBG.backgroundColor = [[SSDB5 theme] colorForKey:@"info_pagenumber_bg_color"];
    
    //page image
    float pageImageWidth = 20.f;
    float pageImageHeight = 30.f;
    float pageNumberFontSize = 14.f;
    UIImageView *pageImage = [[UIImageView alloc] initWithFrame:CGRectMake(leftMargin, topMargin, pageImageWidth, pageImageHeight)];
    [pageImage setImage:[UIImage imageNamed:@"page.png"]];
    [pageNumberBG addSubview:pageImage];
    
    //number page
    self.pageNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(pageImageWidth + leftMargin, topMargin, pageNumberBG.frame.size.width - pageImageWidth - leftMargin, height)];
    self.pageNumberLabel.text = [NSString stringWithFormat:@"%d/%d",1,self.totalPagesNumber];
    self.pageNumberLabel.backgroundColor = [UIColor clearColor];
    self.pageNumberLabel.font = [UIFont fontWithName:[[SSDB5 theme] stringForKey:@"quicksand_font"] size:pageNumberFontSize];
    [pageNumberBG addSubview:self.pageNumberLabel];
    
    //info background
    self.infoBG = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    CALayer *layer = [self.infoBG layer];
    [layer setMasksToBounds:YES];
    if (IS_IPAD)
    {
        [layer setCornerRadius:4.0];
    } else
    {
        [layer setCornerRadius:2.0];
    }
    self.infoBG.backgroundColor = [[SSDB5 theme] colorForKey:@"info_bg_color"];
    self.infoBG.center = CGPointMake(self.center.x, self.center.y);
    [self.infoBG addSubview:self.slideTitle];
    [self.infoBG addSubview:pageNumberBG];
    [self addSubview:self.infoBG];
}

- (void) setPageNumber:(NSInteger)pageNumber
{
    self.pageNumberLabel.text = [NSString stringWithFormat:@"%d/%d", pageNumber, self.totalPagesNumber];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
