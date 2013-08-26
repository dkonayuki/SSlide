//
//  SSSlideShowControlView.m
//  SSlide
//
//  Created by iNghia on 8/24/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import "SSSlideShowControlView.h"
#import <KAProgressLabel/KAProgressLabel.h>

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
    
    UIButton *downloadBtn = [[UIButton alloc] initWithFrame:CGRectMake(leftMargin, topMargin, btnWidth, btnWidth)];
    [downloadBtn setTitle:@"Download" forState:UIControlStateNormal];
    downloadBtn.backgroundColor = [UIColor greenSeaColor];
    [downloadBtn addTarget:self action:@selector(downloadBtnPressed:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:downloadBtn];
    
    leftMargin += 200.f;
    KAProgressLabel *downloadProgress = [[KAProgressLabel alloc] initWithFrame:CGRectMake(leftMargin, topMargin, btnWidth, btnWidth)];
    [downloadProgress setProgressColor:[[SSDB5 theme] colorForKey:@"download_progress_color"]];
    [downloadProgress setTrackColor:[[SSDB5 theme] colorForKey:@"download_track_color"]];
    [downloadProgress setFillColor:[UIColor whiteColor]];
    [downloadProgress setBackgroundColor:[UIColor clearColor]];
    [downloadProgress setBorderWidth:15.f];
    [downloadProgress setProgress:0.25f];
    [downloadProgress setText:@"     25%"];
    [self addSubview:downloadProgress];
}

- (void)streamingBtnPressed:(id)sender
{
    [self.delegate startStreamingCurrentSlideDel];
}

- (void)downloadBtnPressed:(id)sender
{
    [self.delegate downloadCurrentSlideDel];
}

@end
