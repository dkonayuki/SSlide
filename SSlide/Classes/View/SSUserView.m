//
//  SSUserView.m
//  SSlide
//
//  Created by iNghia on 8/21/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import "SSUserView.h"
#import <AKSegmentedControl/AKSegmentedControl.h>
#import <QuartzCore/QuartzCore.h>

@interface SSUserView()

@property (strong, nonatomic) UILabel *usernameLabel;

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
    float usernameSize = 17.f;
    if (IS_IPAD)
    {
        usernameSize *= 2.2;
    }
    self.backgroundColor = [UIColor clearColor];
    float topMargin = IS_IPAD ? [[SSDB5 theme]floatForKey:@"page_top_margin_ipad"] : [[SSDB5 theme]floatForKey:@"page_top_margin_iphone"];
    
    /** username label **/
    self.usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, topMargin)];
    self.usernameLabel.textAlignment = NSTextAlignmentCenter;
    [self.usernameLabel setText:[self.delegate getUsernameDel]];
    self.usernameLabel.font = [UIFont fontWithName:[[SSDB5 theme] stringForKey:@"quicksand_font"] size:usernameSize];
    self.usernameLabel.textColor = [[SSDB5 theme] colorForKey:@"username_color"];
    self.usernameLabel.backgroundColor = [[SSDB5 theme] colorForKey:@"app_title_color"];
    [self addSubview:self.usernameLabel];
    
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
    
    // download btn
    UIButton *downloadedBtn = [[UIButton alloc] init];
    UIImage *downloadedBtnImageNormal = [UIImage imageNamed:@"download-icon.png"];
    
    [downloadedBtn setBackgroundImage:[self imageFromColor:[[SSDB5 theme] colorForKey:@"user_screen_segmented_pressed_color"]] forState:UIControlStateHighlighted];
    [downloadedBtn setBackgroundImage:[self imageFromColor:[[SSDB5 theme] colorForKey:@"user_screen_segmented_pressed_color"]] forState:UIControlStateSelected];
    [downloadedBtn setBackgroundImage:[self imageFromColor:[[SSDB5 theme] colorForKey:@"user_screen_segmented_pressed_color"]] forState:(UIControlStateHighlighted|UIControlStateSelected)];
    
    [downloadedBtn setImage:downloadedBtnImageNormal forState:UIControlStateNormal];
    [downloadedBtn setImage:downloadedBtnImageNormal forState:UIControlStateSelected];
    [downloadedBtn setImage:downloadedBtnImageNormal forState:UIControlStateHighlighted];
    [downloadedBtn setImage:downloadedBtnImageNormal forState:(UIControlStateHighlighted|UIControlStateSelected)];
    float padding = IS_IPAD ? 16.f : 8.f;
    downloadedBtn.imageEdgeInsets = UIEdgeInsetsMake(padding, padding, padding, padding);
    downloadedBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    // my slides btn
    UIButton *mySlidesBtn = [[UIButton alloc] init];
    UIImage *mySlidesBtnImageNormal = [UIImage imageNamed:@"my-slides-icon.png"];
    
    [mySlidesBtn setBackgroundImage:[self imageFromColor:[[SSDB5 theme] colorForKey:@"user_screen_segmented_pressed_color"]] forState:UIControlStateHighlighted];
    [mySlidesBtn setBackgroundImage:[self imageFromColor:[[SSDB5 theme] colorForKey:@"user_screen_segmented_pressed_color"]] forState:UIControlStateSelected];
    [mySlidesBtn setBackgroundImage:[self imageFromColor:[[SSDB5 theme] colorForKey:@"user_screen_segmented_pressed_color"]] forState:(UIControlStateHighlighted|UIControlStateSelected)];
    
    [mySlidesBtn setImage:mySlidesBtnImageNormal forState:UIControlStateNormal];
    [mySlidesBtn setImage:mySlidesBtnImageNormal forState:UIControlStateSelected];
    [mySlidesBtn setImage:mySlidesBtnImageNormal forState:UIControlStateHighlighted];
    [mySlidesBtn setImage:mySlidesBtnImageNormal forState:(UIControlStateHighlighted|UIControlStateSelected)];
    mySlidesBtn.imageEdgeInsets = UIEdgeInsetsMake(padding, padding, padding, padding);
    mySlidesBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;

    // Setting the UIButtons used in the segmented control
    [segmentedControl setButtonsArray:@[downloadedBtn, mySlidesBtn]];    
    [segmentedControl setSelectedIndex:0];
    [self addSubview:segmentedControl];
    
    
    /** SlideListView **/
    topMargin += height;
    self.slideListView = [[SSSlideListView alloc] initWithFrame:CGRectMake(0,
                                                                           topMargin,
                                                                           self.bounds.size.width,
                                                                           self.bounds.size.height - topMargin)
                                                    andDelegate:self.delegate];
    self.slideListView.infiniteLoad = NO;
    [self addSubview:self.slideListView];
}

- (void)refresh
{
    [self.usernameLabel setText:[self.delegate getUsernameDel]];
}

- (UIImage *) imageFromColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (void)segmentedControlValueChanged:(id)sender
{
    AKSegmentedControl *segmentedControl = (AKSegmentedControl *)sender;
    [self.delegate segmentedControlChangedDel:[[segmentedControl selectedIndexes] firstIndex]];
}

@end
