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
    UIButton *downloadBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 200, 100, 50)];
    [downloadBtn setTitle:@"Download" forState:UIControlStateNormal];
    downloadBtn.backgroundColor = [UIColor greenSeaColor];
    [downloadBtn addTarget:self action:@selector(downloadBtnPressed:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:downloadBtn];
}

- (void)downloadBtnPressed:(id)sender
{
    [self.delegate downloadCurrentSlide];
}

@end
