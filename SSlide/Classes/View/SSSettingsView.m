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
#import "SSTag.h"
#import "SSTagAdd.h"

@interface SSSettingsView() <SSTagAddDelegate>
@property (strong, nonatomic) NSMutableArray *tags;
@property (assign, nonatomic) float tagTopMargin;
@property (assign, nonatomic) float tagLeftMargin;
@property (assign, nonatomic) float width;
@property (assign, nonatomic) float height;
@property (strong, nonatomic) SSTagAdd *tagAdd;
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
    self.layer.cornerRadius = 4.f;
    
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

    self.tags = [[NSMutableArray alloc] initWithArray:[[[SSAppData sharedInstance] currentUser] tags]];
    for (NSString *tag in self.tags)
    {
        SSTag *tagView = [[SSTag alloc] initWithFrame:CGRectMake(self.tagLeftMargin, self.tagTopMargin, self.width, self.height) andName:tag];
        if (self.tagLeftMargin + tagView.frame.size.width + 5.f >= self.width)
        {
            CGRect myFrame = tagView.frame;
            myFrame.origin.y += self.height;
            myFrame.origin.x = 0;
            tagView.frame = myFrame;
            self.tagLeftMargin = tagView.frame.size.width + 5.f;
            self.tagTopMargin += self.height;
        }
        else
        {
            self.tagLeftMargin += tagView.frame.size.width + 5.f;
        }
        [self addSubview:tagView];
    }
    self.tagAdd = [[SSTagAdd alloc] initWithFrame:CGRectMake(self.tagLeftMargin, self.tagTopMargin, self.width, self.height)];
    if (self.tagLeftMargin + self.tagAdd.frame.size.width + 5.f >= self.width)
    {
        CGRect myFrame = self.tagAdd.frame;
        myFrame.origin.y += self.height;
        self.tagAdd.frame = myFrame;
    }
    self.tagAdd.delegate = self;
    [self addSubview:self.tagAdd];

    
    //login label
    topMargin += 180.f;
    UILabel *loginLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftMargin, topMargin, self.width, self.height)];
    loginLabel.text = [[SSDB5 theme]stringForKey:@"login_label"];
    loginLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:loginLabel];
    
    //login username
    topMargin += 50.f;
    UITextField *usernameField = [[UITextField alloc] initWithFrame:CGRectMake(leftMargin, topMargin, self.width, self.height)];
    usernameField.textColor = [UIColor whiteColor];
    usernameField.backgroundColor = [UIColor greenColor];
    [usernameField resignFirstResponder];
    [self addSubview:usernameField];
    
    //login password
    topMargin += 50.f;
    UITextField *passwordField = [[UITextField alloc] initWithFrame:CGRectMake(leftMargin, topMargin, self.width, self.height)];
    passwordField.textColor = [UIColor whiteColor];
    passwordField.backgroundColor = [UIColor greenColor];
    passwordField.secureTextEntry = YES;
    [passwordField resignFirstResponder];
    [self addSubview:passwordField];
    
    // login btn
    
    topMargin += 50.f;
    UIButton *authenticateBtn = [[UIButton alloc] initWithFrame:CGRectMake(leftMargin, topMargin, self.width, self.height)];
    [authenticateBtn setTitle:@"Login" forState:UIControlStateNormal];
    authenticateBtn.tag = 1;
    authenticateBtn.backgroundColor = [UIColor greenSeaColor];
    authenticateBtn.layer.cornerRadius = 2.f;
    [authenticateBtn addTarget:self action:@selector(authenticateBtnPressed:) forControlEvents:UIControlEventTouchDown];
    
    [self addSubview:authenticateBtn];
}

- (void) addTag:(NSString *)name;
{
    if ((name != nil) && (![name isEqualToString:@""]))
    {
        [self.tags addObject:name];
        SSTag *tagView = [[SSTag alloc] initWithFrame:CGRectMake(self.tagLeftMargin, self.tagTopMargin, self.width, 40.f) andName:name];
        if (self.tagLeftMargin + tagView.frame.size.width + 5.f >= self.width)
        {
            CGRect myFrame = tagView.frame;
            myFrame.origin.y += self.height;
            myFrame.origin.x = 0.f;
            tagView.frame = myFrame;
            self.tagLeftMargin = tagView.frame.size.width + 5.f;
            self.tagTopMargin += self.height;
        }
        else
        {
            self.tagLeftMargin += tagView.frame.size.width + 5.f;
        }
        [self addSubview:tagView];
        
       //check add button position
        if (self.tagLeftMargin + self.tagAdd.frame.size.width + 5.f >= self.width)
        {
            CGRect myFrame = self.tagAdd.frame;
            myFrame.origin.y += self.height;
            myFrame.origin.x = 0;
            self.tagTopMargin += self.height;
            self.tagLeftMargin = 0;
            self.tagAdd.frame = myFrame;
        }
        else
        {
            CGRect myFrame = self.tagAdd.frame;
            myFrame.origin.x += tagView.frame.size.width + 5.f;
            self.tagAdd.frame = myFrame;
        }
    }
}

- (void)authenticateBtnPressed:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if (btn.tag == 1) {
        [self.delegate loginActionDel];
    } else {
        [self.delegate logoutActionDel];
    }
}

@end
