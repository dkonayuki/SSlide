//
//  SSRootViewController.m
//  SSlide
//
//  Created by iNghia on 8/24/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import "SSRootViewController.h"

@interface SSRootViewController ()

@end

@implementation SSRootViewController

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
    self.pageViewController = [[MNPageViewController alloc] init];
    
    self.pageViewController.delegate = self;
    self.pageViewController.dataSource = self;
    
    // create top viewcontroler
    self.topViewController = [[SSTopViewController alloc] init];
    self.pageViewController.viewController = self.topViewController;
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
    // remove space
    CGRect pageViewRect = self.view.bounds;
    pageViewRect = CGRectInset(pageViewRect, 0.f, 0.f);
    self.pageViewController.view.frame = pageViewRect;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MNPageViewController datasource
- (UIViewController *)mn_pageViewController:(MNPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    if ([viewController isKindOfClass:[SSTopViewController class]]) {
        if (!self.searchViewController) {
            self.searchViewController = [[SSSearchViewController alloc] init];
        }
        return self.searchViewController;
    }
    if ([viewController isKindOfClass:[SSUserViewController class]]) {
        if (!self.topViewController) {
            self.topViewController = [[SSTopViewController alloc] init];
        }
        return self.topViewController;
    }
    return nil;
}

- (UIViewController *)mn_pageViewController:(MNPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    if ([viewController isKindOfClass:[SSTopViewController class]]) {
        if (!self.userViewController) {
            self.userViewController = [[SSUserViewController alloc] init];
        }
        return self.userViewController;
    }
    if ([viewController isKindOfClass:[SSSearchViewController class]]) {
        if (!self.topViewController) {
            self.topViewController = [[SSTopViewController alloc] init];
        }
        return self.topViewController;
    }
    return nil;
}

#pragma mark - MNPageViewController delegate
- (void)mn_pageViewController:(MNPageViewController *)pageViewController willPageToViewController:(SSViewController *)viewController withRatio:(CGFloat)ratio {
    // change alpha of view
}

- (void)mn_pageViewController:(MNPageViewController *)pageViewController willPageFromViewController:(SSViewController *)viewController withRatio:(CGFloat)ratio {
    if (ratio >= 0.9f && [viewController isKindOfClass:[SSSearchViewController class]]) {
        [viewController.view endEditing:YES];
    }
    // change alpha of view
}

@end
