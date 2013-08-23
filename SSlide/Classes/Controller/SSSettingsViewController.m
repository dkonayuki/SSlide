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
    float leftMargin = self.view.bounds.size.width / 6.f;
    float topMargin = self.view.bounds.size.height / 6.f;
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
    [SVProgressHUD showWithStatus:@"checking"];
    [[SSApi sharedInstance] checkUsernamePassword:@"thefoolishman" password:@"pass" result:^(BOOL result) {
        if (result) {
            NSLog(@"Login ok");
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
