//
//  SSSearchView.m
//  SSlide
//
//  Created by iNghia on 8/21/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import "SSSearchView.h"
#import <QuartzCore/QuartzCore.h>

@interface SSSearchView()

@property (strong, nonatomic) UITextField *searchTextField;

@end

@implementation SSSearchView

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
    self.backgroundColor = [[SSDB5 theme] colorForKey:@"search_view_bg_color"];
    self.searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width * 0.8f, 50.f)];
    self.searchTextField.center = self.center;
    self.searchTextField.layer.cornerRadius = 4.5f;
    self.searchTextField.layer.borderColor = [[SSDB5 theme] colorForKey:@"search_textfield_border_color"].CGColor;
    self.searchTextField.layer.borderWidth = 1.f;
    self.searchTextField.backgroundColor = [UIColor clearColor];
    [self addSubview:self.searchTextField];
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
