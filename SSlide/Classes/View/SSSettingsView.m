//
//  SSSettingsView.m
//  SSlide
//
//  Created by iNghia on 8/23/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import "SSSettingsView.h"
#import <QuartzCore/QuartzCore.h>

@implementation SSSettingsView

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
    // self
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 6.f;
    
    // login btn
    float width = 150.f;
    float leftMargin = (self.bounds.size.width - width)/2;
    UIButton *authenticateBtn = [[UIButton alloc] initWithFrame:CGRectMake(leftMargin, 80, width, 55)];
    [authenticateBtn setTitle:@"Login" forState:UIControlStateNormal];
    authenticateBtn.tag = 1;
    authenticateBtn.backgroundColor = [UIColor greenSeaColor];
    authenticateBtn.layer.cornerRadius = 2.f;
    [authenticateBtn addTarget:self action:@selector(authenticateBtnPressed:) forControlEvents:UIControlEventTouchDown];
    
    [self addSubview:authenticateBtn];
}

- (void)authenticateBtnPressed:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if (btn.tag == 1) {
        [self.delegate loginActionDel];
    } else {
        [self.delegate logoutActionDel];
    }
}

@end
