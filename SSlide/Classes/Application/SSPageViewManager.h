//
//  SSPageViewManager.h
//  SSlide
//
//  Created by iNghia on 8/21/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MNPageViewController/MNPageViewController.h>
#import "SSTopViewController.h"
#import "SSSearchViewController.h"
#import "SSUserViewController.h"

@interface SSPageViewManager : NSObject

@property (strong, nonatomic) MNPageViewController *pageViewController;
@property (strong, nonatomic) SSTopViewController  *topViewController;
@property (strong, nonatomic) SSUserViewController *userViewController;
@property (strong, nonatomic) SSSearchViewController *searchViewController;

@end
