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
#import "SSTagsListView.h"

@interface SSSettingsViewController () <SSSettingsViewDelegate, SSTagsListViewDelegate>

@property (strong, nonatomic) SSSettingsView *myView;

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

- (id)initWithDelegate:(id)delegate
{
    self = [super init];
    if (self) {
        self.delegate = delegate;
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
    self.myView = [[SSSettingsView alloc] initWithFrame:CGRectMake(leftMargin, topMargin, width, height) andDelegate:self];
    self.view = self.myView;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SSSetingsViewDelegate
- (void)loginActionDel:(NSString *)username password:(NSString *)password
{
    [SVProgressHUD showWithStatus:@"checking"];
    [[SSApi sharedInstance] checkUsernamePassword:username password:password result:^(BOOL result) {
        if (result) {
            NSLog(@"Login ok");
            SSUser *newUser = [[SSUser alloc] initWith:username password:password];
            [[SSAppData sharedInstance] setCurrentUser:newUser];
            [SSAppData saveAppData];
            [SVProgressHUD showSuccessWithStatus:@"OK"];
            [self.myView refreshPosition];
            // update user settings
            [self.delegate reloadSettingsDataDel];
        } else {
            NSLog(@"Login fail");
            [SVProgressHUD showErrorWithStatus:@"Error"];
        }
    }];
}

- (void)logoutActionDel
{
    [SSAppData sharedInstance].currentUser = [[SSUser alloc] initDefaultUser];
    [SSAppData saveAppData];
    [self.myView refreshPosition];
    // update user settings
    [self.delegate reloadSettingsDataDel];
}

- (BOOL)isLogined
{
    return [[SSAppData sharedInstance] isLogined];
}

- (NSMutableArray *)getTagStringsDel
{
    return [SSAppData sharedInstance].currentUser.tags;
}

#pragma SSTagsListView delegate
- (void)didAddTag:(NSString *)tag
{
    [[SSAppData sharedInstance].currentUser.tags addObject:tag];
    [SSAppData saveAppData];
}

- (void)didRemoveTag:(NSString *)tag
{
    [[SSAppData sharedInstance].currentUser.tags removeObject:tag];
    [SSAppData saveAppData];
}

@end
