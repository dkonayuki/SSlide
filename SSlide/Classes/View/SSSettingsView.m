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
@property (strong, nonatomic) SSTagsListView *tagsListView;
@property (strong, nonatomic) UILabel *authenLabel;
@property (strong, nonatomic) SSTextFieldView *usernameField;
@property (strong, nonatomic) SSTextFieldView *passwordField;
@property (strong, nonatomic) UIButton *authenBtn;

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
    
    // authen label
    leftMargin = 0.f;
    topMargin = self.bounds.size.height - 5*height;
    self.authenLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftMargin, topMargin, self.bounds.size.width, height)];
    self.authenLabel.font = [UIFont fontWithName:[[SSDB5 theme] stringForKey:@"quicksand_font"] size:fontSize];
    self.authenLabel.textAlignment = NSTextAlignmentCenter;
    self.authenLabel.textColor = [[SSDB5 theme] colorForKey:@"setting_label_color"];
    [self addSubview:self.authenLabel];

    // authenBtn
    topMargin = self.bounds.size.height - 3*height/2;
    self.authenBtn = [[UIButton alloc] initWithFrame:CGRectMake(leftMargin, topMargin, self.bounds.size.width, height)];
    self.authenBtn.backgroundColor = [[SSDB5 theme] colorForKey:@"login_button_color"];
    [self.authenBtn addTarget:self action:@selector(authenticateBtnPressed:) forControlEvents:UIControlEventTouchDown];
    [self addSubview:self.authenBtn];
    
    [self refreshPosition];
    self.originViewCenter = self.center;
}

- (void)refreshPosition
{
    float height = IS_IPAD ? 60.f : 40.f;
    NSString *labelText = [self.delegate isLogined] ? [[SSDB5 theme]stringForKey:@"logout_label"] : [[SSDB5 theme]stringForKey:@"login_label"];
    
    // tags list
    if (self.tagsListView) {
        [self.tagsListView removeFromSuperview];
    }
    float topMargin = height + 10.f;
    float leftMargin = 10.f;
    float width = self.bounds.size.width - 2*leftMargin;
    float tagListHeight = self.bounds.size.height - 5*height - topMargin;
    self.tagsListView = [[SSTagsListView alloc] initWithFrame:CGRectMake(leftMargin, topMargin, width, tagListHeight)
                                                  andDelegate:self.delegate
                                                andTagStrings:[self.delegate getTagStringsDel]];
    [self addSubview:self.tagsListView];
    
    if ([self.delegate isLogined]) {
        // tagsListView
        CGRect tmp = self.tagsListView.frame;
        tmp.size.height = self.bounds.size.height - 3*height;
        self.tagsListView.frame = tmp;
        
        // authenLabel
        tmp = self.authenLabel.frame;
        tmp.origin.y = self.bounds.size.height - 3*height;
        self.authenLabel.frame = tmp;
        [self.authenLabel setText:labelText];
        
        // usernameField
        if (self.usernameField) {
            [self.usernameField removeFromSuperview];
        }
        
        // passwordField
        if (self.passwordField) {
            [self.passwordField removeFromSuperview];
        }
        
        // authen Btn
        [self.authenBtn setTitle:labelText forState:UIControlStateNormal];
        self.authenBtn.tag = -1;
    } else {
        // tagsListView
        CGRect tmp = self.tagsListView.frame;
        tmp.size.height = self.bounds.size.height - 3*height;
        self.tagsListView.frame = tmp;
        
        // authenLabel
        tmp = self.authenLabel.frame;
        tmp.origin.y = self.bounds.size.height - 5*height;
        self.authenLabel.frame = tmp;
        [self.authenLabel setText:labelText];
        
        // usernameField and passwordField
        [self addLoginTextField:height];
        
        // authen Btn
        [self.authenBtn setTitle:labelText forState:UIControlStateNormal];
        self.authenBtn.tag = 1;
    }
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

#pragma mark - private
- (void)addLoginTextField:(float)height
{
    //login username
    float topMargin = self.bounds.size.height - 4*height;
    self.usernameField = [[SSTextFieldView alloc] initWithFrame:CGRectMake(0.f, topMargin, self.bounds.size.width, height)
                                                       delegate:self
                                                      imageName:@"login_username.png"
                                                          color:[[SSDB5 theme] colorForKey:@"username_textfield_color"]
                                                     isPassword:NO
                                                    placeholder:@"Username"];
    [self addSubview:self.usernameField];
    
    //login password
    topMargin = self.bounds.size.height - 3*height;
    self.passwordField = [[SSTextFieldView alloc] initWithFrame:CGRectMake(0.f, topMargin, self.bounds.size.width, height)
                                                       delegate:self
                                                      imageName:@"login_password.png"
                                                          color:[[SSDB5 theme] colorForKey:@"password_textfield_color"]
                                                     isPassword:YES
                                                    placeholder:@"Password"];
    [self addSubview:self.passwordField];
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

@end
