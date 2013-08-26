//
//  SSSlideShowControlView.m
//  SSlide
//
//  Created by iNghia on 8/24/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import "SSSlideShowControlView.h"

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
    [streamingBtn setTitle:@"Streaming" forState:UIControlStateNormal];
    streamingBtn.backgroundColor = [UIColor greenSeaColor];
    [streamingBtn addTarget:self action:@selector(streamingBtnPressed:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:streamingBtn];
    
    leftMargin += 200.f;
    
    UIButton *downloadBtn = [[UIButton alloc] initWithFrame:CGRectMake(leftMargin, topMargin, btnWidth, btnWidth)];
    [downloadBtn setTitle:@"Download" forState:UIControlStateNormal];
    downloadBtn.backgroundColor = [UIColor greenSeaColor];
    [downloadBtn addTarget:self action:@selector(downloadBtnPressed:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:downloadBtn];
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
