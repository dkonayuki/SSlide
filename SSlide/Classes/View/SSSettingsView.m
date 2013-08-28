//
//  SSSettingsView.m
//  SSlide
//
//  Created by iNghia on 8/23/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import "SSSettingsView.h"
#import <QuartzCore/QuartzCore.h>
#import "SSAppData.h"
#import "SSTagsListView.h"

@interface SSSettingsView() < UITextFieldDelegate>

@property (assign, nonatomic) float tagTopMargin;
@property (assign, nonatomic) float tagLeftMargin;
@property (assign, nonatomic) float width;
@property (assign, nonatomic) float height;
@property (assign, nonatomic) CGPoint originViewCenter;

@end

@implementation SSSettingsView

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
    // self
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = IS_IPAD ? 10.f : 5.f;
    
    //tags label
    self.width = self.bounds.size.width;
    self.height = 40.f;
    float leftMargin = 0.f;
    float topMargin = 10.f;
    
    UILabel *tagsLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftMargin, topMargin, self.width, self.height)];
    tagsLabel.text = [[SSDB5 theme]stringForKey:@"tags_label"];
    tagsLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:tagsLabel];
    
    topMargin += 40.f;
    //init tags
    self.tagTopMargin = topMargin;
    self.tagLeftMargin = leftMargin;
    
    leftMargin = 10.f;
    float width = self.bounds.size.width - 2*leftMargin;
    float height = width*2/3;
    SSTagsListView *listView = [[SSTagsListView alloc] initWithFrame:CGRectMake(leftMargin, topMargin, width, height)
                                                         andDelegate:self.delegate
                                                       andTagStrings:[self.delegate getTagStringsDel]];
    [self addSubview:listView];
    
        
    leftMargin = 0.f;
    
    //login label
    topMargin += IS_IPAD ? 300.f : 125.f;
    UILabel *loginLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftMargin, topMargin, self.width, self.height)];
    loginLabel.text = [[SSDB5 theme]stringForKey:@"login_label"];
    loginLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:loginLabel];
    
    //login username
    topMargin += 50.f;
    UITextField *usernameField = [[UITextField alloc] initWithFrame:CGRectMake(leftMargin, topMargin, self.width, self.height)];
    usernameField.textColor = [UIColor whiteColor];
    usernameField.backgroundColor = [[SSDB5 theme] colorForKey:@"username_textfield_color"];
    usernameField.placeholder = @"Username";
    [usernameField resignFirstResponder];
    usernameField.delegate = self;
    [self addSubview:usernameField];
    
    //login password
    topMargin += self.height;
    UITextField *passwordField = [[UITextField alloc] initWithFrame:CGRectMake(leftMargin, topMargin, self.width, self.height)];
    passwordField.textColor = [UIColor whiteColor];
    passwordField.backgroundColor = [[SSDB5 theme] colorForKey:@"password_textfield_color"];
    passwordField.secureTextEntry = YES;
    passwordField.placeholder = @"Password";
    [passwordField resignFirstResponder];
    passwordField.delegate = self;
    [self addSubview:passwordField];
    
    // login btn
    topMargin += 50.f;
    UIButton *authenticateBtn = [[UIButton alloc] initWithFrame:CGRectMake(leftMargin, topMargin, self.width, self.height)];
    [authenticateBtn setTitle:@"Login" forState:UIControlStateNormal];
    authenticateBtn.tag = 1;
    authenticateBtn.backgroundColor = [[SSDB5 theme] colorForKey:@"login_button_color"];
    [authenticateBtn addTarget:self action:@selector(authenticateBtnPressed:) forControlEvents:UIControlEventTouchDown];
    
    [self addSubview:authenticateBtn];
    
    self.originViewCenter = self.center;
}

- (void)authenticateBtnPressed:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if (btn.tag == 1) {
        [self.delegate loginActionDel];
    } else {
        [self.delegate logoutActionDel];
    }
    [self closeKeyboardAndExit];
}

#pragma mark - UITextField delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:0.5f
                     animations:^(void) {
                         float dy = IS_IPAD ? 120.f : 200.f;
                         self.center = CGPointMake(self.originViewCenter.x, self.originViewCenter.y - dy);
                     }
                     completion:nil];
}

- (void)closeKeyboardAndExit
{
    [self endEditing:YES];
    [UIView animateWithDuration:0.5f
                     animations:^(void) {
                         self.center = self.originViewCenter;
                     }
                     completion:nil];
}

@end
