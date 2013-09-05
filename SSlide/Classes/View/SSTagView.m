//
//  SSTagView.m
//  SSlide
//
//  Created by iNghia on 8/28/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import "SSTagView.h"
#import <QuartzCore/QuartzCore.h>

#define padding 4.f

@interface SSTagView()

@property (strong, nonatomic) UIButton *label;
@property (strong, nonatomic) UIButton *button;

@end

@implementation SSTagView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andDelegate:(id)delegate text:(NSString *)text fontSize:(float)fontSize
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.delegate = delegate;
        self.text = text;
        self.fontSize = fontSize;
        [self initView];
    }
    return self;
}

- (void)initView
{
    float margin =  IS_IPAD ? 10.f : 8.f;
    float corner = IS_IPAD ? 4.f : 3.f;
    self.backgroundColor = [[SSDB5 theme] colorForKey:@"tag_bg_color"];
    self.layer.cornerRadius = corner;
    self.layer.masksToBounds = YES;
    
    self.label = [[UIButton alloc] init];
    self.label.backgroundColor = [UIColor clearColor];
    [self.label setTintColor:[UIColor whiteColor]];
    [self.label setTitle:self.text forState:UIControlStateNormal];
    [self.label.titleLabel setFont:[UIFont systemFontOfSize:self.fontSize]];
    [self.label addTarget:self action:@selector(toggleDeleteBtn) forControlEvents:UIControlEventTouchDown];
    [self addSubview:self.label];
    
    self.button = [[UIButton alloc] init];
    [self.button setImage:[UIImage imageNamed:@"delete.png"] forState:UIControlStateNormal];
    [self.button setImageEdgeInsets:UIEdgeInsetsMake(margin, margin, margin, margin)];
    [self.button addTarget:self action:@selector(deleteTag) forControlEvents:UIControlEventTouchDown];
    [self addSubview:self.button];
    self.button.hidden = YES;
}

- (void)refresh
{
    CGSize size = [self.label.titleLabel.text sizeWithFont:[UIFont systemFontOfSize:self.fontSize]];

    self.label.frame = CGRectMake(padding, padding, size.width + padding, size.height);
    [self.label sizeToFit];
    
    CGRect curFrame = self.frame;
    if (![self.button isHidden]) {
        self.button.frame = CGRectMake(size.width + 2*padding, 0.f, size.height + 2*padding, size.height + 2*padding);
        curFrame.size.width = size.width + size.height + 4*padding;
    } else {
        curFrame.size.width = size.width + 2*padding;
    }
    curFrame.size.height = size.height + 2*padding;
    self.frame = curFrame;
}

- (void)toggleDeleteBtn
{
    self.button.hidden = !self.button.hidden;
    [self refresh];
    [self.delegate redrawDel];
}

- (void)deleteTag
{
    [self.delegate removeTagDel:self];
}

@end
