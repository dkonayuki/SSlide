//
//  SSRootViewController.h
//  SSlide
//
//  Created by iNghia on 8/24/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import "SSViewController.h"
#import "SSTopViewController.h"
#import "SSSearchViewController.h"
#import "SSUserViewController.h"
#import "MNPageViewController.h"

@interface SSRootViewController : SSViewController <MNPageViewControllerDataSource, MNPageViewControllerDelegate>

@property (nonatomic, strong) MNPageViewController *pageViewController;
@property (strong, nonatomic) SSTopViewController  *topViewController;
@property (strong, nonatomic) SSUserViewController *userViewController;
@property (strong, nonatomic) SSSearchViewController *searchViewController;

@end
