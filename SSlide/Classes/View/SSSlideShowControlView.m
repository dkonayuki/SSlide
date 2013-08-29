//
//  SSSlideShowControlView.m
//  SSlide
//
//  Created by iNghia on 8/24/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import "SSSlideShowControlView.h"
#import <QuartzCore/QuartzCore.h>

#define NORMAL 0
#define PRESSED 1

@interface SSSlideShowControlView()

@property (strong, nonatomic) UIButton *downloadBtn;
@property (strong, nonatomic) UIButton *streamingBtn;
@property (strong, nonatomic) UIButton *penBtn;
@property (strong, nonatomic) UIButton *eraseBtn;
@property (strong, nonatomic) UIView *downloadBtnBackground;
@property (assign, nonatomic) float downloadBtnHeight;

@end

@implementation SSSlideShowControlView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)initView
{
    self.backgroundColor = [UIColor clearColor];
    
    float btnWidth = IS_IPAD ? 100.f : 50.f;
    float margin = IS_IPAD ? 36.f : 18.f;
    float padding = IS_IPAD ? 16.f : 8.f;
    float corner = IS_IPAD ? 6.f : 3.f;
    float border = IS_IPAD ? 2.f : 1.f;
    
    //streaming button
    self.streamingBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, btnWidth, btnWidth)];
    //[streamingBtn setTitle:@"Streaming" forState:UIControlStateNormal];
    if ([self.delegate isMasterDel]) {
        [self.streamingBtn setImage:[UIImage imageNamed:@"streaming.png"] forState:UIControlStateNormal];
    } else {
        [self.streamingBtn setImage:[UIImage imageNamed:@"access.png"] forState:UIControlStateNormal];
    }
    [self.streamingBtn setBackgroundImage:[self imageFromColor:[[SSDB5 theme] colorForKey:@"slideshow_btn_bg"]] forState:UIControlStateNormal];
    [self.streamingBtn addTarget:self action:@selector(streamingBtnPressed:) forControlEvents:UIControlEventTouchDown];
    [self.streamingBtn setImageEdgeInsets:UIEdgeInsetsMake(padding, padding, padding, padding)];
    self.streamingBtn.center = CGPointMake(self.frame.size.width/2 - (btnWidth + margin) * 3/2, self.center.y);
    self.streamingBtn.tag = NORMAL;
    CALayer *layer = [self.streamingBtn layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:corner];
    [layer setBorderColor:[[SSDB5 theme] colorForKey:@"info_pagenumber_bg_color"].CGColor];
    [layer setBorderWidth:border];
    [self addSubview:self.streamingBtn];

    //pen button
    self.penBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, btnWidth, btnWidth)];
    [self.penBtn setImage:[UIImage imageNamed:@"pen.png"] forState:UIControlStateNormal];
    [self.penBtn setBackgroundImage:[self imageFromColor:[[SSDB5 theme] colorForKey:@"slideshow_btn_bg"]] forState:UIControlStateNormal];
    [self.penBtn setImageEdgeInsets:UIEdgeInsetsMake(padding, padding, padding, padding)];
    [self.penBtn addTarget:self action:@selector(penBtnPressed:) forControlEvents:UIControlEventTouchDown];
    self.penBtn.center = CGPointMake(self.frame.size.width/2 - (btnWidth + margin)/2, self.center.y);
    self.penBtn.tag = NORMAL;
    layer = [self.penBtn layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:corner];
    [layer setBorderColor:[[SSDB5 theme] colorForKey:@"info_pagenumber_bg_color"].CGColor];
    [layer setBorderWidth:border];
    [self addSubview:self.penBtn];

    //erase button
    self.eraseBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, btnWidth, btnWidth)];
    [self.eraseBtn setImage:[UIImage imageNamed:@"eraser.png"] forState:UIControlStateNormal];
    [self.eraseBtn setBackgroundImage:[self imageFromColor:[[SSDB5 theme] colorForKey:@"slideshow_btn_bg"]] forState:UIControlStateNormal];
    [self.eraseBtn setImage:[UIImage imageNamed:@"eraser_pressed.png"] forState:UIControlStateHighlighted];
    [self.eraseBtn setBackgroundImage:[self imageFromColor:[[SSDB5 theme] colorForKey:@"slideshow_btn_bg_pressed"]] forState:UIControlStateHighlighted];
    [self.eraseBtn setImageEdgeInsets:UIEdgeInsetsMake(padding, padding, padding, padding)];
    [self.eraseBtn addTarget:self action:@selector(eraseBtnPressed:) forControlEvents:UIControlEventTouchDown];
    self.eraseBtn.center = CGPointMake(self.frame.size.width/2 + (btnWidth + margin)/2, self.center.y);
    self.eraseBtn.tag = NORMAL;
    layer = [self.eraseBtn layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:corner];
    [layer setBorderColor:[[SSDB5 theme] colorForKey:@"info_pagenumber_bg_color"].CGColor];
    [layer setBorderWidth:border];
    [self addSubview:self.eraseBtn];

    // dowload button background
    self.downloadBtnHeight = btnWidth - corner;
    self.downloadBtnBackground = [[UIView alloc] initWithFrame:CGRectMake(0 + corner/2, 0 + corner/2, btnWidth - corner, btnWidth- corner)];
    self.downloadBtnBackground.backgroundColor = [[SSDB5 theme] colorForKey:@"app_title_color"];
    self.downloadBtnBackground.center = CGPointMake(self.frame.size.width/2 + (btnWidth + margin) *3/2, self.center.y);
    layer = [self.downloadBtn layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:corner];
    [self addSubview:self.downloadBtnBackground];
    
    //download button
    self.downloadBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, btnWidth, btnWidth)];
    [self.downloadBtn setImage:[UIImage imageNamed:@"download_slide.png"] forState:UIControlStateNormal];
    [self.downloadBtn setBackgroundImage:[self imageFromColor:[[SSDB5 theme] colorForKey:@"slideshow_btn_bg"]] forState:UIControlStateNormal];
    [self.downloadBtn addTarget:self action:@selector(downloadBtnPressed:) forControlEvents:UIControlEventTouchDown];
    self.downloadBtn.center = CGPointMake(self.frame.size.width/2 + (btnWidth + margin) *3/2, self.center.y);
    //[self.downloadBtn setImageEdgeInsets:UIEdgeInsetsMake(padding, padding, padding, padding)];
    self.downloadBtn.tag = NORMAL;
    layer = [self.downloadBtn layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:corner];
    [layer setBorderColor:[[SSDB5 theme] colorForKey:@"info_pagenumber_bg_color"].CGColor];
    [layer setBorderWidth:border];
    [self addSubview:self.downloadBtn];
    
    if ([self.delegate slideIdDownloaded]) {
        [self setDownloadBtnForStateDownloaded];
    }
}

- (void)eraseBtnPressed:(id)sender
{
    [self.delegate clearDrawing];
}

- (void)penBtnPressed:(id)sender
{
    if (self.penBtn.tag == NORMAL)
    {
        [self.penBtn setImage:[UIImage imageNamed:@"pen_pressed.png"] forState:UIControlStateNormal];
        [self.penBtn setBackgroundImage:[self imageFromColor:[[SSDB5 theme] colorForKey:@"slideshow_btn_bg_pressed"]] forState:UIControlStateNormal];
        self.penBtn.tag = PRESSED;
        [self.delegate startDrawing];
    }
    else
    {
        [self.penBtn setImage:[UIImage imageNamed:@"pen.png"] forState:UIControlStateNormal];
        [self.penBtn setBackgroundImage:[self imageFromColor:[[SSDB5 theme] colorForKey:@"slideshow_btn_bg"]] forState:UIControlStateNormal];
        self.penBtn.tag = NORMAL;
        [self.delegate stopDrawing];
    }
}

- (void)streamingBtnPressed:(id)sender
{
    if (self.streamingBtn.tag == NORMAL)
    {
        if ([self.delegate isMasterDel])
        {
            [self.streamingBtn setImage:[UIImage imageNamed:@"streaming_pressed.png"] forState:UIControlStateNormal];
        }
        else
        {
             [self.streamingBtn setImage:[UIImage imageNamed:@"access_pressed.png"] forState:UIControlStateNormal];
        }
        [self.streamingBtn setBackgroundImage:[self imageFromColor:[[SSDB5 theme] colorForKey:@"slideshow_btn_bg_pressed"]] forState:UIControlStateNormal];
        self.streamingBtn.tag = PRESSED;
        [self.delegate startStreamingCurrentSlideDel];
    }
    else
    {
        if ([self.delegate isMasterDel])
        {
            [self.streamingBtn setImage:[UIImage imageNamed:@"streaming.png"] forState:UIControlStateNormal];
        }
        else
        {
            [self.streamingBtn setImage:[UIImage imageNamed:@"access.png"] forState:UIControlStateNormal];
        }
        [self.streamingBtn setBackgroundImage:[self imageFromColor:[[SSDB5 theme] colorForKey:@"slideshow_btn_bg"]] forState:UIControlStateNormal];
        self.streamingBtn.tag = NORMAL;
        [self.delegate stopStreamingCurrentSlideDel];
    }
}

- (void)downloadBtnPressed:(id)sender
{
    if (self.downloadBtn.tag == NORMAL)
    {
        [self.downloadBtn setImage:[UIImage imageNamed:@"download_slide_pressed.png"] forState:UIControlStateNormal];
        [self.downloadBtn setBackgroundImage:[self imageFromColor:[UIColor clearColor]] forState:UIControlStateNormal];
        self.downloadBtn.tag = PRESSED;
        [self.delegate downloadCurrentSlideDel];
    } else {
        [SVProgressHUD showErrorWithStatus:@"Already downloaded!"];
    }
}

- (void)setDownloadProgress:(float)percent
{
    float per = percent * self.downloadBtnHeight;
    CGRect rect = self.downloadBtnBackground.frame;
    rect.size.height = per;
    self.downloadBtnBackground.frame = rect;
}

- (void)setDownloadBtnForStateDownloaded
{
    CGRect rect = self.downloadBtnBackground.frame;
    rect.size.height = self.downloadBtnHeight;
    self.downloadBtnBackground.frame = rect;
    self.downloadBtnBackground.backgroundColor = [UIColor whiteColor];
    
    [self.downloadBtn setImage:[UIImage imageNamed:@"download_slide_pressed.png"] forState:UIControlStateNormal];
    [self.downloadBtn setBackgroundImage:[self imageFromColor:[UIColor clearColor]] forState:UIControlStateNormal];
    self.downloadBtn.tag = PRESSED;
}

- (void)setDownloadBtnForStateNormal
{
    [self.downloadBtn setImage:[UIImage imageNamed:@"download_slide.png"] forState:UIControlStateNormal];
    [self.downloadBtn setBackgroundImage:[self imageFromColor:[[SSDB5 theme] colorForKey:@"slideshow_btn_bg"]] forState:UIControlStateNormal];
    self.downloadBtn.tag = NORMAL;
}

- (UIImage *) imageFromColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (void)setFinishDownload
{
    [self setDownloadBtnForStateDownloaded];
}

- (void)offStreamingBtn
{
    if ([self.delegate isMasterDel]) {
        [self.streamingBtn setImage:[UIImage imageNamed:@"streaming.png"] forState:UIControlStateNormal];
    } else {
        [self.streamingBtn setImage:[UIImage imageNamed:@"access.png"] forState:UIControlStateNormal];
    }
    [self.streamingBtn setBackgroundImage:[self imageFromColor:[[SSDB5 theme] colorForKey:@"slideshow_btn_bg"]] forState:UIControlStateNormal];
    self.streamingBtn.tag = NORMAL;
}

@end
