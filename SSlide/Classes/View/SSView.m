//
//  SSView.m
//  SSlide
//
//  Created by iNghia on 8/21/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import "SSView.h"

@implementation SSView
@synthesize delegate = mDelegate;

- (id)initWithFrame:(CGRect)frame andDelegate:(id)delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.delegate = delegate;
        [self initView];
    }
    return self;
}

- (void)initView
{

}

- (void)updateContent
{

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
