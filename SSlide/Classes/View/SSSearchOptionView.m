//
//  SSSearchOptionView.m
//  SSlide
//
//  Created by iNghia on 9/11/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import "SSSearchOptionView.h"
#import "SSImageHelper.h"
#import <AKSegmentedControl/AKSegmentedControl.h>

@implementation SSSearchOptionView

- (void)initView
{
    AKSegmentedControl *segmentedControl = [[AKSegmentedControl alloc] initWithFrame:self.bounds];
    [segmentedControl addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    segmentedControl.backgroundColor = [[SSDB5 theme] colorForKey:@"user_screen_segmented_normal_color"];
    
    // Setting the behavior mode of the control
    [segmentedControl setSegmentedControlMode:AKSegmentedControlModeSticky];
    
    // Setting the separator image
    [segmentedControl setSeparatorImage:[UIImage imageNamed:@"segmented-separator.png"]];
    
    float btnW = self.bounds.size.width/3;
    float btnH = self.bounds.size.height;
    
    // relevance button
    UIButton *relevanceBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, btnW, btnH)];
    [relevanceBtn setTitle:@"Relevance" forState:UIControlStateNormal];
    [self setBtnAttribute:relevanceBtn];
     
    // mostviewed button
    UIButton *mostviewedBtn = [[UIButton alloc] initWithFrame:CGRectMake(btnW, 0, btnW, btnH)];
    [mostviewedBtn setTitle:@"Most viewed" forState:UIControlStateNormal];
    [self setBtnAttribute:mostviewedBtn];
    
    // latest button
    UIButton *latestBtn = [[UIButton alloc] initWithFrame:CGRectMake(2*btnW, 0, btnW, btnH)];
    [latestBtn setTitle:@"Latest" forState:UIControlStateNormal];
    [self setBtnAttribute:latestBtn];
    
    // Setting the UIButtons used in the segmented control
    [segmentedControl setButtonsArray:@[relevanceBtn, mostviewedBtn, latestBtn]];
    [segmentedControl setSelectedIndex:0];
    [self addSubview:segmentedControl];
}

- (void)segmentedControlValueChanged:(id)sender
{
    AKSegmentedControl *segmentedControl = (AKSegmentedControl *)sender;
    [self.delegate searchOptionSeletedDel:[[segmentedControl selectedIndexes] firstIndex]];
}

#pragma mark - private
- (void)setBtnAttribute:(UIButton *)btn
{
    float fontSize = IS_IPAD ? 30.f : 16.f;
    [btn.titleLabel setFont:[UIFont fontWithName:[[SSDB5 theme] stringForKey:@"quicksand_font"] size:fontSize]];
    
    UIColor *pressedColor = [[SSDB5 theme] colorForKey:@"user_screen_segmented_pressed_color"];
    UIImage *pressedImage = [SSImageHelper imageFromColor:pressedColor];
    UIColor *normalColor = [[SSDB5 theme] colorForKey:@"user_screen_segmented_pressed_color"];
    UIImage *normalImage = [SSImageHelper imageFromColor:normalColor];
    
    [btn setBackgroundImage:pressedImage forState:UIControlStateHighlighted];
    [btn setBackgroundImage:pressedImage forState:UIControlStateSelected];
    [btn setBackgroundImage:pressedImage forState:(UIControlStateHighlighted|UIControlStateSelected)];
    
    [btn setImage:normalImage forState:UIControlStateNormal];
    [btn setImage:normalImage forState:UIControlStateSelected];
    [btn setImage:normalImage forState:UIControlStateHighlighted];
    [btn setImage:normalImage forState:(UIControlStateHighlighted|UIControlStateSelected)];
}

@end
