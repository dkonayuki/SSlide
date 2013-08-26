//
//  SSSlideShowControlView.m
//  SSlide
//
//  Created by iNghia on 8/24/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import "SSSlideShowControlView.h"
#import <KAProgressLabel/KAProgressLabel.h>

@interface SSSlideShowControlView()

@property (strong, nonatomic) KAProgressLabel *downloadProgLabel;
@property (strong, nonatomic) UIButton *downloadBtn;

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
    self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    
    float btnWidth = IS_IPAD ? 100.f : 50.f;
    float topMargin = (self.bounds.size.height - btnWidth)/2;
    float leftMargin = 100.f;
    
    UIButton *streamingBtn = [[UIButton alloc] initWithFrame:CGRectMake(leftMargin, topMargin, btnWidth, btnWidth)];
    //[streamingBtn setTitle:@"Streaming" forState:UIControlStateNormal];
    if ([self.delegate isMasterDel]) {
        [streamingBtn setBackgroundImage:[UIImage imageNamed:@"publish_icon.png"] forState:UIControlStateNormal];
    } else {
        [streamingBtn setBackgroundImage:[UIImage imageNamed:@"subscribe_icon.png"] forState:UIControlStateNormal];
    }
    [streamingBtn addTarget:self action:@selector(streamingBtnPressed:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:streamingBtn];
    
    leftMargin += 200.f;
    
    self.downloadBtn = [[UIButton alloc] initWithFrame:CGRectMake(leftMargin, topMargin, btnWidth, btnWidth)];
    [self.downloadBtn setBackgroundImage:[UIImage imageNamed:@"download_slide_icon.png"] forState:UIControlStateNormal];
    [self.downloadBtn addTarget:self action:@selector(downloadBtnPressed:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:self.downloadBtn];
    
    self.downloadProgLabel = [[KAProgressLabel alloc] initWithFrame:CGRectMake(leftMargin, topMargin, btnWidth, btnWidth)];
    [self.downloadProgLabel setProgressColor:[[SSDB5 theme] colorForKey:@"download_progress_color"]];
    [self.downloadProgLabel setTrackColor:[[SSDB5 theme] colorForKey:@"download_track_color"]];
    [self.downloadProgLabel setFillColor:[UIColor whiteColor]];
    [self.downloadProgLabel setBackgroundColor:[UIColor clearColor]];
    [self.downloadProgLabel setBorderWidth:15.f];
    [self.downloadProgLabel setTextAlignment:NSTextAlignmentCenter];
    [self setDownloadProgress:0];
    [self addSubview:self.downloadProgLabel];
    // hide download ProgLabel
    [self.downloadProgLabel setHidden:YES];
}

- (void)streamingBtnPressed:(id)sender
{
    [self.delegate startStreamingCurrentSlideDel];
}

- (void)downloadBtnPressed:(id)sender
{
    [self.downloadProgLabel setHidden:NO];
    [self.downloadBtn setHidden:YES];

    [self.delegate downloadCurrentSlideDel];
}

- (void)setDownloadProgress:(float)percent
{
    float per = percent * 100;
    [self.downloadProgLabel setText:[NSString stringWithFormat:@"%d/100", (int)per]];
    [self.downloadProgLabel setProgress:percent];
}

- (void)setFinishDownload
{
    [self.downloadProgLabel setText:@"OK"];
    [self.downloadProgLabel setProgress:1.f];
}

@end
