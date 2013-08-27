//
//  SSUserView.m
//  SSlide
//
//  Created by iNghia on 8/21/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import "SSUserView.h"
#import <AKSegmentedControl/AKSegmentedControl.h>

@interface SSUserView()

@end

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
    
    float topMargin = [[SSDB5 theme]floatForKey:@"page_top_margin"];
    if (IS_IPAD)
    {
        topMargin *= 2.2;
    }
    
    /** username label **/
    UILabel *usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, topMargin)];
    usernameLabel.textAlignment = NSTextAlignmentCenter;
    [usernameLabel setText:[self.delegate getUsernameDel]];
    //TODO: set font, color
    [self addSubview:usernameLabel];
    
    /** segmented control **/
    float leftMargin = 0;
    float width = self.bounds.size.width - 2*leftMargin;
    float height = IS_IPAD ? [[SSDB5 theme] floatForKey:@"user_screen_segmented_height_ipad"] : [[SSDB5 theme] floatForKey:@"user_screen_segmented_height_iphone"];
    
    AKSegmentedControl *segmentedControl = [[AKSegmentedControl alloc] initWithFrame:CGRectMake(leftMargin, topMargin, width, height)];
    [segmentedControl addTarget:self action:@selector(segmentedControlValueChanged:) forControlEvents:UIControlEventValueChanged];

    segmentedControl.backgroundColor = [[SSDB5 theme] colorForKey:@"user_screen_segmented_normal_color"];
    
    // Setting the behavior mode of the control
    [segmentedControl setSegmentedControlMode:AKSegmentedControlModeSticky];
    
    // Setting the separator image
    [segmentedControl setSeparatorImage:[UIImage imageNamed:@"segmented-separator.png"]];
    
    UIImage *hightlighImage = [UIImage imageNamed:@"segmented-bg-pressed-center.png"];

    // download btn
    UIButton *downloadedBtn = [[UIButton alloc] init];
    UIImage *downloadedBtnImageNormal = [UIImage imageNamed:@"download-icon.png"];
    
    [downloadedBtn setBackgroundImage:hightlighImage forState:UIControlStateHighlighted];
    [downloadedBtn setBackgroundImage:hightlighImage forState:UIControlStateSelected];
    [downloadedBtn setBackgroundImage:hightlighImage forState:(UIControlStateHighlighted|UIControlStateSelected)];
    
    [downloadedBtn setImage:downloadedBtnImageNormal forState:UIControlStateNormal];
    [downloadedBtn setImage:downloadedBtnImageNormal forState:UIControlStateSelected];
    [downloadedBtn setImage:downloadedBtnImageNormal forState:UIControlStateHighlighted];
    [downloadedBtn setImage:downloadedBtnImageNormal forState:(UIControlStateHighlighted|UIControlStateSelected)];
    
    // my slides btn
    UIButton *mySlidesBtn = [[UIButton alloc] init];
    UIImage *mySlidesBtnImageNormal = [UIImage imageNamed:@"my-slides-icon.png"];
    
    [mySlidesBtn setBackgroundImage:hightlighImage forState:UIControlStateHighlighted];
    [mySlidesBtn setBackgroundImage:hightlighImage forState:UIControlStateSelected];
    [mySlidesBtn setBackgroundImage:hightlighImage forState:(UIControlStateHighlighted|UIControlStateSelected)];
    
    [mySlidesBtn setImage:mySlidesBtnImageNormal forState:UIControlStateNormal];
    [mySlidesBtn setImage:mySlidesBtnImageNormal forState:UIControlStateSelected];
    [mySlidesBtn setImage:mySlidesBtnImageNormal forState:UIControlStateHighlighted];
    [mySlidesBtn setImage:mySlidesBtnImageNormal forState:(UIControlStateHighlighted|UIControlStateSelected)];

    
    // Setting the UIButtons used in the segmented control
    [segmentedControl setButtonsArray:@[downloadedBtn, mySlidesBtn]];    
    [segmentedControl setSelectedIndex:0];
    [self addSubview:segmentedControl];
    
    
    /** SlideListView **/
    topMargin += 50.f;
    self.slideListView = [[SSSlideListView alloc] initWithFrame:CGRectMake(0,
                                                                           topMargin,
                                                                           self.bounds.size.width,
                                                                           self.bounds.size.height - topMargin)];
    self.slideListView.delegate = self.delegate;
    [self addSubview:self.slideListView];
}

- (void)segmentedControlValueChanged:(id)sender
{
    AKSegmentedControl *segmentedControl = (AKSegmentedControl *)sender;
    [self.delegate segmentedControlChangedDel:[[segmentedControl selectedIndexes] firstIndex]];
}

@end
