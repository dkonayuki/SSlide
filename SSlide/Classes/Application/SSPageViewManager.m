//
//  SSPageViewManager.m
//  SSlide
//
//  Created by iNghia on 8/21/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import "SSPageViewManager.h"

@interface SSPageViewManager() <MNPageViewControllerDataSource, MNPageViewControllerDelegate>

@end

@implementation SSPageViewManager

- (id)init
{
    self = [super init];
    if (self) {
        self.pageViewController = [[MNPageViewController alloc] init];
        self.pageViewController.dataSource = self;
        self.pageViewController.delegate = self;
        // create top viewcontroler
        self.topViewController = [[SSTopViewController alloc] init];
        // set as current viewcontroller
        self.pageViewController.viewController = self.topViewController;
    }
    return self;
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
    // change alpha of view
}

@end
