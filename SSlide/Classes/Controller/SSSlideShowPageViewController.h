//
//  SSSlideShowPageViewController.h
//  SSlide
//
//  Created by iNghia on 8/23/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import "SSViewController.h"
#import "SSSlideShowViewController.h"

@protocol SSSlideShowPageViewControllerDelegate <NSObject>

- (void)closePopup;

@end

@interface SSSlideShowPageViewController : SSViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (strong, nonatomic) UIPageViewController *pageController;
@property (weak, nonatomic) id delegate;

- (id)initWithSlideshow:(SSSlideshow *)slideshow andDelegate:(id)delegate;


@end
