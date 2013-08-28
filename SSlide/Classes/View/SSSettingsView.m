//
//  SSSettingsView.m
//  SSlide
//
//  Created by iNghia on 8/23/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import "SSSettingsView.h"
#import <QuartzCore/QuartzCore.h>
#import "SSTagsListView.h"
#import "SSTextFieldView.h"

@interface SSSettingsView() <SSTextFieldViewDelegate>

@property (assign, nonatomic) CGPoint originViewCenter;
@property (strong, nonatomic) SSTextFieldView *usernameField;
@property (strong, nonatomic) SSTextFieldView *passwordField;

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
    
    float width = self.bounds.size.width;
    float height = IS_IPAD ? 60.f : 40.f;
    float leftMargin = 0.f;
    float topMargin = 10.f;
    float fontSize = IS_IPAD ? [[SSDB5 theme] floatForKey:@"setting_label_font_size_ipad"] : [[SSDB5 theme] floatForKey:@"setting_label_font_size_iphone"];
    
    // tags label
    UILabel *tagsLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftMargin, topMargin, width, height)];
    tagsLabel.text = [[SSDB5 theme]stringForKey:@"tags_label"];
    tagsLabel.font = [UIFont fontWithName:[[SSDB5 theme] stringForKey:@"quicksand_font"] size:fontSize];
    tagsLabel.textAlignment = NSTextAlignmentCenter;
    tagsLabel.textColor = [[SSDB5 theme] colorForKey:@"setting_label_color"];
    [self addSubview:tagsLabel];
    
    // tags list
    topMargin += height;
    leftMargin = 10.f;
    width = self.bounds.size.width - 2*leftMargin;
    float tagListHeight = self.bounds.size.height - 5*height - topMargin;
    SSTagsListView *listView = [[SSTagsListView alloc] initWithFrame:CGRectMake(leftMargin, topMargin, width, tagListHeight)
                                                         andDelegate:self.delegate
                                                       andTagStrings:[self.delegate getTagStringsDel]];
    [self addSubview:listView];
    
    // login label
    leftMargin = 0.f;
    topMargin = self.bounds.size.height - 5*height;
    UILabel *loginLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftMargin, topMargin, self.bounds.size.width, height)];
    loginLabel.text = [[SSDB5 theme]stringForKey:@"login_label"];
    loginLabel.font = [UIFont fontWithName:[[SSDB5 theme] stringForKey:@"quicksand_font"] size:fontSize];
    loginLabel.textAlignment = NSTextAlignmentCenter;
    loginLabel.textColor = [[SSDB5 theme] colorForKey:@"setting_label_color"];
    [self addSubview:loginLabel];
    
    //login username
    topMargin = self.bounds.size.height - 4*height;
    self.usernameField = [[SSTextFieldView alloc] initWithFrame:CGRectMake(leftMargin, topMargin, self.bounds.size.width, height)
                                                       delegate:self
                                                      imageName:@"login_username.png"
                                                          color:[[SSDB5 theme] colorForKey:@"username_textfield_color"]
                                                     isPassword:NO
                                                    placeholder:@"Username"];
    [self addSubview:self.usernameField];
    
    //login password
    topMargin = self.bounds.size.height - 3*height;
    self.passwordField = [[SSTextFieldView alloc] initWithFrame:CGRectMake(leftMargin, topMargin, self.bounds.size.width, height)
                                                       delegate:self
                                                      imageName:@"login_password.png"
                                                          color:[[SSDB5 theme] colorForKey:@"password_textfield_color"]
                                                     isPassword:YES
                                                    placeholder:@"Password"];
    [self addSubview:self.passwordField];
    
    // login btn
    topMargin = self.bounds.size.height - 3*height/2;
    UIButton *authenticateBtn = [[UIButton alloc] initWithFrame:CGRectMake(leftMargin, topMargin, self.bounds.size.width, height)];
    [authenticateBtn setTitle:[[SSDB5 theme]stringForKey:@"login_label"] forState:UIControlStateNormal];
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
        [self.delegate loginActionDel:[self.usernameField getText]
                             password:[self.passwordField getText]];
    } else {
        [self.delegate logoutActionDel];
    }
    [self closeKeyboardAndExit];
}

#pragma mark - SSTextFieldView delegate
- (void)textFieldDidBeginEditingDel
{
    [UIView animateWithDuration:0.5f
                     animations:^(void) {
                         float dy = IS_IPAD ? 120.f : 210.f;
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
