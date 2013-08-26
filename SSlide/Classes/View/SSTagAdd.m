//
//  SSTagAdd.m
//  SSlide
//
//  Created by techcamp on 2013/08/26.
//  Copyright (c) 2013年 S2. All rights reserved.
//

#import "SSTagAdd.h"

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
}

- (IBAction)addTag:(id)sender
{
    [self.delegate addTag:self.tagField.text];
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
