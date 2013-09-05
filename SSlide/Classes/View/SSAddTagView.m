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
    float corner = IS_IPAD ? 4.f : 3.f;
    float border = IS_IPAD ? 2.f : 1.f;
    float margin = IS_IPAD ? 10.f : 8.f;

    self.layer.borderColor = [[SSDB5 theme]colorForKey:@"tag_bg_color"].CGColor;
    self.layer.borderWidth = border;
    self.layer.cornerRadius = corner;
    self.layer.masksToBounds = YES;
    
    self.textField = [[UITextField alloc] init];
    self.textField.backgroundColor = [UIColor clearColor];
    self.textField.placeholder = @"new tag";
    self.textField.font = [UIFont systemFontOfSize:self.fontSize];
    [self.textField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self addSubview:self.textField];
    
    self.button = [[UIButton alloc] init];
    [self.button setImage:[UIImage imageNamed:@"add.png"] forState:UIControlStateNormal];
    [self.button setImageEdgeInsets:UIEdgeInsetsMake(margin, margin, margin, margin)];
    [self.button setBackgroundColor:[[SSDB5 theme]colorForKey:@"tag_bg_color"]];
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
    if (!self.textField.text | ([self.textField.text length] == 0)) {
        [SVProgressHUD showErrorWithStatus:@"Empty tag!"];
        return;
    }
    
    NSString *text = [NSString stringWithString:self.textField.text];
    
    [self.textField setText:@""];
    [self refresh];
    [self.delegate addTagDel:text];
    [self endEditing:YES];
}

- (void)textFieldDidChange:(UITextField *)textField
{
    [self refresh];
    [self.delegate redrawDel];
}

@end
