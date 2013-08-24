//
//  SSSlideShowPageViewController.m
//  SSlide
//
//  Created by iNghia on 8/23/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import "SSSlideShowPageViewController.h"
#import "SSApi.h"

@interface SSSlideShowPageViewController () <SSSlideSHowViewControllerDelegate>

@property (strong, nonatomic) SSSlideshow *currentSlide;
@property (assign, nonatomic) NSInteger totalPage;

@end

@implementation SSSlideShowPageViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithSlideshow:(SSSlideshow *)slideshow andDelegate:(id)delegate
{
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.currentSlide = slideshow;
        self.totalPage = self.currentSlide.totalSlides;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationVertical options:nil];
    
    self.pageController.dataSource = self;
    [[self.pageController view] setFrame:[[self view] bounds]];
    
    if (![self.currentSlide checkIsDownloaded] && [self.currentSlide extendedInfoIsNil]) {
        [[SSApi sharedInstance] addExtendedSlideInfo:self.currentSlide result:^(BOOL result) {
            [self initViewController];
        }];
    } else {
        [self initViewController];
    }
}

- (void)initViewController
{
    SSSlideShowViewController *initialViewController = [self viewControllerAtIndex:1];
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:self.pageController];
    [[self view] addSubview:[self.pageController view]];
    [self.pageController didMoveToParentViewController:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (SSSlideShowViewController *)viewControllerAtIndex:(NSUInteger)index
{
    SSSlideShowViewController *slideShowViewController = [[SSSlideShowViewController alloc] initWithCurrentSlideshow:self.currentSlide pageIndex:index andDelegate:self];
    return slideShowViewController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(SSSlideShowViewController *)viewController pageIndex];
    if (index == 1) {
        return nil;
    }
    index --;
    
    return [self viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(SSSlideShowViewController *)viewController pageIndex];
    index ++;
    if (index == self.totalPage + 1) {
        return nil;
    }

    return [self viewControllerAtIndex:index];
}


- (void)closePopup
{
    [self.delegate closePopup];
}

@end
