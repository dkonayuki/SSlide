//
//  SSSlideShowPageViewController.h
//  SSlide
//
//  Created by iNghia on 8/23/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import "SSViewController.h"
#import "SSSlideShowViewController.h"

@interface SSSlideShowPageViewController : SSViewController <UIPageViewControllerDataSource>

@property (strong, nonatomic) UIPageViewController *pageController;

- (id)initWithSlideshow:(SSSlideshow *)slideshow;

@end
