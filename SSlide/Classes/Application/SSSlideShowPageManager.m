//
//  SSSlideShowPageManager.m
//  SSlide
//
//  Created by iNghia on 8/22/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import "SSSlideShowPageManager.h"

@interface SSSlideShowPageManager() <MNPageViewControllerDataSource, MNPageViewControllerDelegate>

@property (strong, nonatomic) SSSlideshow *currentSlide;
@property (assign, nonatomic) NSInteger totalPage;
@property (assign, nonatomic) NSInteger currentPage;
@property (strong, nonatomic) SSSlideShowViewController *currentViewController;

@end

@implementation SSSlideShowPageManager

- (id)initWithSlideshow:(SSSlideshow *)slideshow
{
    self = [super init];
    if (self) {
        self.currentSlide = slideshow;
        self.currentPage = 1;
        self.totalPage = slideshow.totalSlides;
        
        self.pageViewController = [[MNPageViewController alloc] init];
        self.pageViewController.dataSource = self;
        self.pageViewController.delegate = self;
        
        self.currentViewController = [[SSSlideShowViewController alloc] initWithCurrentSlideshow:self.currentSlide pageIndex:self.currentPage];
        self.pageViewController.viewController = self.currentViewController;
    }
    return self;
}

- (void)refresh
{
    self.totalPage = self.currentSlide.totalSlides;
}

#pragma mark - MNPageViewController datasource
- (UIViewController *)mn_pageViewController:(MNPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    if (self.currentPage >= self.totalPage) {
        return nil;
    }
    self.currentPage ++;
    self.currentViewController = [[SSSlideShowViewController alloc] initWithCurrentSlideshow:self.currentSlide pageIndex:self.currentPage];
    
    return self.currentViewController;
}

- (UIViewController *)mn_pageViewController:(MNPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    if (self.currentPage <= 1) {
        return nil;
    }
    self.currentPage --;
    self.currentViewController = [[SSSlideShowViewController alloc] initWithCurrentSlideshow:self.currentSlide pageIndex:self.currentPage];

    return self.currentViewController;
}

@end
