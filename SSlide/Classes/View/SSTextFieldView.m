//
//  SSTextFieldView.m
//  SSlide
//
//  Created by iNghia on 8/28/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import "SSTextFieldView.h"

@interface SSTextFieldView() <UITextFieldDelegate>

@property (strong, nonatomic) UIImageView *icon;
@property (strong, nonatomic) UITextField *textField;
@property (strong, nonatomic) NSString *imageName;
@property (strong, nonatomic) UIColor *color;
@property (assign, nonatomic) BOOL isPassword;
@property (strong, nonatomic) NSString *placeholder;

@end

@implementation SSTextFieldView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame delegate:(id)delegate imageName:(NSString *)image color:(UIColor *)color isPassword:(BOOL)isPassword placeholder:(NSString *)placeholder
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.delegate = delegate;
        self.imageName = image;
        self.color = color;
        self.isPassword = isPassword;
        self.placeholder = placeholder;
        [self initView];
    }
    return self;
}

- (void)initView
{
    float topMargin = IS_IPAD ? 16.f : 8.f;
    float leftMargin = IS_IPAD ? 28.f : 14.f;
    self.backgroundColor = self.color;
    self.icon = [[UIImageView alloc] initWithFrame:CGRectMake(leftMargin, topMargin, self.bounds.size.height - 2*leftMargin, self.bounds.size.height - 2*topMargin)];
    self.icon.image = [UIImage imageNamed:self.imageName];
    self.icon.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.icon];
    
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(self.bounds.size.height, 0, self.bounds.size.width - self.bounds.size.height, self.bounds.size.height)];
    self.textField.secureTextEntry = self.isPassword;
    self.textField.placeholder = self.placeholder;
    [self.textField setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    self.textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.textField.textColor = [UIColor whiteColor];
    self.textField.delegate = self;
    float textFontSize = (IS_IPAD) ? 28.f : 14.f;
    self.textField.font = [UIFont fontWithName:[[SSDB5 theme] stringForKey:@"quicksand_font"]  size:textFontSize];
    [self addSubview:self.textField];
}

- (NSString *)getText
{
    return self.textField.text;
}

#pragma mark - UITextField delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self.delegate textFieldDidBeginEditingDel];
}

@end
