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
    float topMargin = 12.f;
    float width = 100.f;
    float height = 40.f;
    float pageWidth = 85.f;
    float titleFontSize = 16.f;
    float pageNumberFontSize = 14.f;

    if (IS_IPAD)
    {
        pageNumberFontSize *= 2.2;
        titleFontSize *= 2.2;
        leftMargin *= 2.2;
        topMargin *= 2.2;
        pageWidth *= 2.2;
        height *= 2.2;
    }
    //title
    self.slideTitle = [[UILabel alloc] initWithFrame:CGRectMake(leftMargin, topMargin, width, height)];
    self.slideTitle.text = self.title;
    self.slideTitle.backgroundColor = [UIColor clearColor];
    self.slideTitle.textColor = [[SSDB5 theme] colorForKey:@"info_title_text_color"];
    self.slideTitle.font = [UIFont fontWithName:[[SSDB5 theme] stringForKey:@"quicksand_font"] size:titleFontSize];
    [self.slideTitle sizeToFit];
    
    width = self.slideTitle.frame.size.width + leftMargin + pageWidth;
    //number background
    UIView *pageNumberBG =[[UIView alloc] initWithFrame:CGRectMake(width - pageWidth, 0, pageWidth, height)];
    pageNumberBG.backgroundColor = [[SSDB5 theme] colorForKey:@"info_pagenumber_bg_color"];
    
    leftMargin += 5.f;
    topMargin = 8.f;
    float pageImageWidth = 15.f;
    float pageImageHeight = 22.f;

    if (IS_IPAD)
    {
        pageImageHeight *= 2.2;
        pageImageWidth *= 2.2;
        leftMargin += 5.f;
        topMargin *= 2.2;
    }
    //page image
    UIImageView *pageImage = [[UIImageView alloc] initWithFrame:CGRectMake(leftMargin, topMargin, pageImageWidth, pageImageHeight)];
    [pageImage setImage:[UIImage imageNamed:@"page.png"]];
    [pageNumberBG addSubview:pageImage];
    
    leftMargin += 8.f;
    topMargin = 0.f;
    if (IS_IPAD)
    {
        topMargin *= 2.2;
        leftMargin += 8.f;
    }
    //number page
    self.pageNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(pageImageWidth + leftMargin, topMargin, pageNumberBG.frame.size.width - pageImageWidth - leftMargin, height)];
    self.pageNumberLabel.text = [NSString stringWithFormat:@"%d/%d",1,self.totalPagesNumber];
    self.pageNumberLabel.backgroundColor = [UIColor clearColor];
    self.pageNumberLabel.font = [UIFont fontWithName:[[SSDB5 theme] stringForKey:@"quicksand_font"] size:pageNumberFontSize];
    self.pageNumberLabel.textColor = [[SSDB5 theme] colorForKey:@"info_page_text_color"];
    [pageNumberBG addSubview:self.pageNumberLabel];
    
    //info background
    self.infoBG = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    CALayer *layer = [self.infoBG layer];
    [layer setMasksToBounds:YES];
    [layer setBorderColor:[[SSDB5 theme] colorForKey:@"info_pagenumber_bg_color"].CGColor];
    layer.masksToBounds = YES;
    if (IS_IPAD)
    {
        [layer setBorderWidth:2.0];
        [layer setCornerRadius:8.0];
    } else
    {
        [layer setBorderWidth:1.0];
        [layer setCornerRadius:4.0];
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
