//
//  SSSettingsViewController.m
//  SSlide
//
//  Created by iNghia on 8/23/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import "SSSettingsViewController.h"
#import "SSSettingsView.h"
#import "SSApi.h"
#import "SSAppData.h"
#import "SSUser.h"

@interface SSSettingsViewController () <SSSettingsViewDelegate>

@end

@implementation SSSettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    float wR = IS_IPAD ? 5.f : 10.f;
    
    float leftMargin = self.view.bounds.size.width / wR;
    float topMargin = self.view.bounds.size.height / wR;
    float width = self.view.bounds.size.width - 2*leftMargin;
    float height = self.view.bounds.size.height - 2*topMargin;
    SSSettingsView *myView = [[SSSettingsView alloc] initWithFrame:CGRectMake(leftMargin, topMargin, width, height) andDelegate:self];
    self.view = myView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SSSetingsViewDelegate
- (void)loginActionDel
{
    NSString *username = @"thefoolishman";
    NSString *password = @"pass";
    
    [SVProgressHUD showWithStatus:@"checking"];
    [[SSApi sharedInstance] checkUsernamePassword:username password:password result:^(BOOL result) {
        if (result) {
            NSLog(@"Login ok");
            SSUser *newUser = [[SSUser alloc] initWith:username password:password];
            [[SSAppData sharedInstance] setCurrentUser:newUser];
            [SSAppData saveAppData];
            [SVProgressHUD showSuccessWithStatus:@"OK"];
        } else {
            NSLog(@"Login fail");
            [SVProgressHUD showErrorWithStatus:@"Error"];
        }
    }];
}

- (void)logoutActionDel
{
    
}

@end
