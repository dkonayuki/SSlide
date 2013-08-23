//
//  SSUserView.m
//  SSlide
//
//  Created by iNghia on 8/21/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import "SSUserView.h"
#import <AKSegmentedControl/AKSegmentedControl.h>

@implementation SSUserView

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
    self.backgroundColor = [[SSDB5 theme] colorForKey:@"user_view_bg_color"];
    
    // segmented control
    float topMargin = 100.f;
    float leftMargin = self.bounds.size.width/5.f;
    float width = self.bounds.size.width - 2*leftMargin;
    float height = 50.f;
    
    AKSegmentedControl *segmentedControl = [[AKSegmentedControl alloc] initWithFrame:CGRectMake(leftMargin, topMargin, width, height)];
    [segmentedControl addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    [segmentedControl setContentEdgeInsets:UIEdgeInsetsMake(2.0, 2.0, 3.0, 2.0)];
    // Setting the behavior mode of the control
    [segmentedControl setSegmentedControlMode:AKSegmentedControlModeSticky];
}

- (void)segmentedControlValueChanged:(id)sender
{
    
}

@end
