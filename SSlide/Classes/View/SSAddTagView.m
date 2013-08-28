//
//  SSAddTagView.m
//  SSlide
//
//  Created by iNghia on 8/28/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import "SSAddTagView.h"
#import <QuartzCore/QuartzCore.h>

#define padding 4.f

@interface SSAddTagView()

@property (strong, nonatomic) UITextField *textField;
@property (strong, nonatomic) UIButton *button;

@end

@implementation SSAddTagView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andDelegate:(id)delegate fontSize:(float)fontSize
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.delegate = delegate;
        self.fontSize = fontSize;
        [self initView];
    }
    return self;
}

- (void)initView
{
    //self.backgroundColor = [UIColor grayColor];
    self.layer.borderColor = [UIColor grayColor].CGColor;
    self.layer.borderWidth = 1.f;
    self.layer.cornerRadius = 2.f;
    
    self.textField = [[UITextField alloc] init];
    self.textField.backgroundColor = [UIColor clearColor];
    self.textField.placeholder = @"new tag";
    self.textField.font = [UIFont systemFontOfSize:self.fontSize];
    [self.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self addSubview:self.textField];
    
    self.button = [[UIButton alloc] init];
    [self.button setTitle:@"+" forState:UIControlStateNormal];
    [self.button setBackgroundColor:[UIColor greenSeaColor]];
    [self.button addTarget:self action:@selector(addTag) forControlEvents:UIControlEventTouchDown];
    [self addSubview:self.button];
}

- (void)refresh
{
    NSString *placeholder = @"new tag";
    float minW = [placeholder sizeWithFont:[UIFont systemFontOfSize:self.fontSize]].width;
    CGSize size;
    if ([self.textField.text length] > 0) {
        size = [self.textField.text sizeWithFont:[UIFont systemFontOfSize:self.fontSize]];
    } else {
        size = [self.textField.placeholder sizeWithFont:[UIFont systemFontOfSize:self.fontSize]];
    }
    size.width = size.width < minW ? minW : size.width;
    self.textField.frame = CGRectMake(padding, padding, size.width + padding, size.height);
    [self.textField sizeToFit];
    
    CGRect curFrame = self.frame;
    self.button.frame = CGRectMake(size.width + 2*padding, 0.f, size.height + 2*padding, size.height + 2*padding);
    curFrame.size.width = size.width + size.height + 4*padding;
    
    curFrame.size.height = size.height + 2*padding;
    self.frame = curFrame;
}

- (void)addTag
{
    NSString *text = [NSString stringWithString:self.textField.text];
    [self.textField setText:@""];
    [self refresh];
    [self.delegate addTagDel:text];
}

- (void)textFieldDidChange:(UITextField *)textField
{
    [self refresh];
    [self.delegate redrawDel];
}

@end
