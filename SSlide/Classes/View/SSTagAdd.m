//
//  SSTagAdd.m
//  SSlide
//
//  Created by techcamp on 2013/08/26.
//  Copyright (c) 2013年 S2. All rights reserved.
//

#import "SSTagAdd.h"
#import <QuartzCore/QuartzCore.h>

@interface SSTagAdd()
@property (strong, nonatomic) UITextField *tagField;
@property (strong, nonatomic) UIButton *addButton;
@end

@implementation SSTagAdd

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initView];
    }
    return self;
}

- (void) initView
{
    float topMargin = 0;
    float leftMargin = 0;
    float width = 60.f;
    float height = 30.f;

    //tag label
    self.tagField = [[UITextField alloc]initWithFrame:CGRectMake(leftMargin, topMargin, width, height)];
    [self addSubview:self.tagField];
    
    //add tag button
    self.addButton = [[UIButton alloc] initWithFrame:CGRectMake(width, topMargin, 30.f, height)];
    [self.addButton setTitle:@"+" forState:UIControlStateNormal];
    self.addButton.backgroundColor = [UIColor colorFromHexCode:@"777777"];
    [self.addButton addTarget:self action:@selector(addTag:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.addButton];
    CGRect myFrame = self.frame;
    myFrame.size.width = width + 30.f;
    self.frame = myFrame;
    self.layer.borderColor = [[SSDB5 theme] colorForKey:@"tag_bg_color"].CGColor;
    self.layer.borderWidth = 1.f;
}

- (void)addTag:(id)sender
{
    [self.delegate addTag:self.tagField.text];
    [self.tagField setText:@""];
}

@end
