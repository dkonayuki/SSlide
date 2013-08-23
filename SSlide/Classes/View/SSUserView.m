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
    float height = 37.f;
    
    AKSegmentedControl *segmentedControl = [[AKSegmentedControl alloc] initWithFrame:CGRectMake(leftMargin, topMargin, width, height)];
    [segmentedControl addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];
    
    // Setting the resizable background image
    UIImage *backgroundImage = [[UIImage imageNamed:@"segmented-bg.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)];
    [segmentedControl setBackgroundImage:backgroundImage];
    
    // Setting the content edge insets to adapte to you design
    [segmentedControl setContentEdgeInsets:UIEdgeInsetsMake(2.0, 2.0, 3.0, 2.0)];
    
    // Setting the behavior mode of the control
    [segmentedControl setSegmentedControlMode:AKSegmentedControlModeSticky];
    
    // Setting the separator image
    [segmentedControl setSeparatorImage:[UIImage imageNamed:@"segmented-separator.png"]];
    
    UIImage *buttonBackgroundImagePressedLeft = [[UIImage imageNamed:@"segmented-bg-pressed-left.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 4.0, 0.0, 1.0)];
    UIImage *buttonBackgroundImagePressedCenter = [[UIImage imageNamed:@"segmented-bg-pressed-center.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 4.0, 0.0, 1.0)];
    
    // download btn
    UIButton *downloadedBtn = [[UIButton alloc] init];
    UIImage *downloadedBtnImageNormal = [UIImage imageNamed:@"download-icon.png"];
    
    [downloadedBtn setImageEdgeInsets:UIEdgeInsetsMake(0.0, 0.0, 0.0, 5.0)];
    [downloadedBtn setBackgroundImage:buttonBackgroundImagePressedLeft forState:UIControlStateHighlighted];
    [downloadedBtn setBackgroundImage:buttonBackgroundImagePressedLeft forState:UIControlStateSelected];
    [downloadedBtn setBackgroundImage:buttonBackgroundImagePressedLeft forState:(UIControlStateHighlighted|UIControlStateSelected)];
    [downloadedBtn setImage:downloadedBtnImageNormal forState:UIControlStateNormal];
    [downloadedBtn setImage:downloadedBtnImageNormal forState:UIControlStateSelected];
    [downloadedBtn setImage:downloadedBtnImageNormal forState:UIControlStateHighlighted];
    [downloadedBtn setImage:downloadedBtnImageNormal forState:(UIControlStateHighlighted|UIControlStateSelected)];
    
    // my slides btn
    UIButton *mySlidesBtn = [[UIButton alloc] init];
    UIImage *mySlidesBtnImageNormal = [UIImage imageNamed:@"my-slides-icon.png"];
    
    [mySlidesBtn setBackgroundImage:buttonBackgroundImagePressedCenter forState:UIControlStateHighlighted];
    [mySlidesBtn setBackgroundImage:buttonBackgroundImagePressedCenter forState:UIControlStateSelected];
    [mySlidesBtn setBackgroundImage:buttonBackgroundImagePressedCenter forState:(UIControlStateHighlighted|UIControlStateSelected)];
    [mySlidesBtn setImage:mySlidesBtnImageNormal forState:UIControlStateNormal];
    [mySlidesBtn setImage:mySlidesBtnImageNormal forState:UIControlStateSelected];
    [mySlidesBtn setImage:mySlidesBtnImageNormal forState:UIControlStateHighlighted];
    [mySlidesBtn setImage:mySlidesBtnImageNormal forState:(UIControlStateHighlighted|UIControlStateSelected)];
    
    // Setting the UIButtons used in the segmented control
    [segmentedControl setButtonsArray:@[downloadedBtn, mySlidesBtn]];
    
    [segmentedControl setSelectedIndex:0];
    [self addSubview:segmentedControl];
    
    // setting btn
    float rightMargin = 10.f;
    width = 40.f;
    leftMargin = self.bounds.size.width - rightMargin*2 - width;
    UIButton *settingsBtn = [[UIButton alloc] initWithFrame:CGRectMake(leftMargin, topMargin, width, width)];
    [settingsBtn setImage:[UIImage imageNamed:@"settings-icon.png"] forState:UIControlStateNormal];
    //settingsBtn.backgroundColor = [UIColor whiteColor];
    [settingsBtn addTarget:self action:@selector(settingsBtnPressed) forControlEvents:UIControlEventTouchDown];
    [self addSubview:settingsBtn];
}

- (void)segmentedControlValueChanged:(id)sender
{
    AKSegmentedControl *segmentedControl = (AKSegmentedControl *)sender;
    [self.delegate segmentedControlChangedDel:[[segmentedControl selectedIndexes] firstIndex]];
}

- (void)settingsBtnPressed
{
    [self.delegate settingsBtnPressedDel];
}

@end
