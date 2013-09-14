//
//  SSSlideShowPageViewController.m
//  SSlide
//
//  Created by iNghia on 8/23/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import "SSSlideShowPageViewController.h"
#import "SSAppData.h"
#import "SSApi.h"
#import "SSSlideShowControlView.h"
#import "SSSlideShowInfoView.h"
#import "SSStreamingManager.h"
#import "SSDrawingView.h"

@interface SSSlideShowPageViewController () <SSSlideSHowViewControllerDelegate, SSSlideShowControlViewDelegate, SSStreamingManagerDelegate, SSDrawingViewDelegate>

@property (strong, nonatomic) SSSlideshow *currentSlide;
@property (assign, nonatomic) NSInteger totalPage;
@property (strong, nonatomic) SSSlideShowControlView *controlView;
@property (strong, nonatomic) SSSlideShowInfoView *infoView;
@property (strong, nonatomic) SSStreamingManager *streamingManager;
@property (strong, nonatomic) SSDrawingView *drawingView;

@end

@implementation SSSlideShowPageViewController

- (id)initWithSlideshow:(SSSlideshow *)slideshow andDelegate:(id)delegate
{
    self = [super init];
    if (self) {
        self.delegate = delegate;
        self.currentSlide = [[SSAppData sharedInstance] getDownloadedSlide:slideshow.slideId];
        if(self.currentSlide == nil) {
            self.currentSlide = slideshow;
        } else {
            self.currentSlide.channel = slideshow.channel;
        }
        self.totalPage = self.currentSlide.totalSlides;
        
        BOOL isMaster = self.currentSlide.channel ? NO : YES;
        self.streamingManager = [[SSStreamingManager alloc] initWithSlideshow:self.currentSlide asMaster:isMaster];
        self.streamingManager.delegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationVertical options:nil];
    
    self.pageController.dataSource = self;
    self.pageController.delegate = self;
    [[self.pageController view] setFrame:[[self view] bounds]];
    
    if (![self.currentSlide checkIsDownloaded] && [self.currentSlide extendedInfoIsNil]) {
        [SVProgressHUD showWithStatus:@"loading"];
        [[SSApi sharedInstance] addExtendedSlideInfo:self.currentSlide result:^(BOOL result) {
            [SVProgressHUD dismiss];
            [self initViewController];
        }];
    } else {
        [self initViewController];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.streamingManager stopSynchronizing];
    [self.controlView offStreamingBtn];
}

#pragma mark - private
- (void)initViewController
{
    SSSlideShowViewController *initialViewController = [self viewControllerAtIndex:1];
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:self.pageController];
    [[self view] addSubview:[self.pageController view]];
    [self.pageController didMoveToParentViewController:self];
    
    // drawing view
    self.drawingView = [[SSDrawingView alloc] initWithFrame:self.view.bounds andDelegate:self];
    self.drawingView.lineColor = [UIColor orangeColor];
    float lineWidth = IS_IPAD ? [[SSDB5 theme] floatForKey:@"drawing_pen_width_ipad"] : [[SSDB5 theme] floatForKey:@"drawing_pen_width_iphone"];
    self.drawingView.lineWidth = lineWidth;
    [self.view addSubview:self.drawingView];
    self.drawingView.hidden = YES;
    
    // control view
    float width = IS_IPAD ? [[SSDB5 theme] floatForKey:@"slide_control_view_height_ipad"] : [[SSDB5 theme] floatForKey:@"slide_control_view_height_iphone"];
    float height = IS_IPAD ? 580.f : 270.f;
    CGRect rect = CGRectMake(self.view.bounds.size.width - width, 0, height, width);
    self.controlView = [[SSSlideShowControlView alloc] initWithFrame:rect andDelegate:self];
    self.controlView.transform = CGAffineTransformMakeRotation(M_PI_2);
    self.controlView.center = CGPointMake(self.view.bounds.size.width + width/2, self.view.bounds.size.height/2);
    [self.view addSubview:self.controlView];
    
    //info view
    self.infoView = [[SSSlideShowInfoView alloc] initWithFrame:CGRectMake(0, 0, 100.f, width) andTitle:self.currentSlide.title andTotalPages:self.currentSlide.totalSlides];
    [self.view addSubview:self.infoView];
    //[self.infoView sizeToFit];
    self.infoView.transform = CGAffineTransformMakeRotation(M_PI_2);
    self.infoView.center = CGPointMake(width/2, self.view.center.y);
    self.infoView.alpha = 0.f;
}

#pragma mark - SSSlideShowViewControllerDelegate
- (void)closePopup
{
    [self.delegate closePopupDel];
}

- (BOOL)isMasterDel
{
    return [self.streamingManager isMasterDevice];
}

- (void)toogleInfoView
{
    if (self.infoView.alpha == 0) {
        [UIView animateWithDuration:0.5f animations:^(void) {
            self.infoView.alpha = 1.0;
        }];
    }
    else {
        [UIView animateWithDuration:0.5f animations:^(void) {
            self.infoView.alpha = 0;
        }];    
    }
}

- (void)showControlView
{
    [UIView animateWithDuration:0.5f
                     animations:^(void) {
                         float cW = IS_IPAD ? [[SSDB5 theme] floatForKey:@"slide_control_view_height_ipad"] : [[SSDB5 theme] floatForKey:@"slide_control_view_height_iphone"];
                         self.controlView.center = CGPointMake(self.view.bounds.size.width - cW/2, self.view.center.y);
                     }
                     completion:^(BOOL finished) {
                        
                     }];
}

- (void)hideControlView
{
    NSLog(@"hide control view");
    [UIView animateWithDuration:0.35f
                     animations:^(void) {
                         float cW = IS_IPAD ? [[SSDB5 theme] floatForKey:@"slide_control_view_height_ipad"] : [[SSDB5 theme] floatForKey:@"slide_control_view_height_iphone"];
                         self.controlView.center = CGPointMake(self.view.bounds.size.width + cW/2, self.view.center.y);
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}

- (void)downloadCurrentSlideDel
{
    if (![self.currentSlide checkIsDownloadedAsNew]) {
        [self.currentSlide download:^(float percent) {
            //NSLog(@"download: %f", percent);
            [self.controlView setDownloadProgress:percent];
        } completion:^(BOOL result){
            [SVProgressHUD showSuccessWithStatus:@"Download completed!"];
            [self.delegate reloadSlidesListDel];
            [self.controlView setFinishDownload];
        }];
    } else {
        [SVProgressHUD showErrorWithStatus:@"Already exists!"];
    }
}

- (void)startStreamingCurrentSlideDel
{
    [self.streamingManager startSynchronizing];
}

- (void)stopStreamingCurrentSlideDel
{
    [self.streamingManager stopSynchronizing];
    [self.controlView offStreamingBtn];
}

- (void)startDrawing
{
    self.drawingView.hidden = NO;
}

- (void)stopDrawing
{
    self.drawingView.hidden = YES;
}

- (void)clearDrawing
{
    [self.drawingView clear];
    [self.streamingManager didClearDrawingView];
}

- (BOOL)slideIdDownloaded
{
    return [self.currentSlide checkIsDownloadedAsNew];
}

#pragma mark - SSStreamingManagerDelegate
- (void)gotoPageWithNumDel:(NSUInteger)pageNum
{
    [self gotoPage:pageNum];
}

- (void)didAddPointsFromMasterDel:(NSArray *)points
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(void) {
        [self.drawingView drawNewPoints:points];
    });
}

- (void)didClearFromMasterDel
{
    [self.drawingView clear];
}

- (void)disconnectedFromServerDel
{
    [self.controlView offStreamingBtn];
}

- (void)didEndTouchFromMasterDel
{
    [self.drawingView didEndTouch];
}

#pragma mark - SSDrawingViewDelegate
- (void)didAddPointsDel:(NSArray *)points
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(void){
        [self.streamingManager didAddPointsInDrawingView:points];
    });
}

- (void)didEndTouchDel
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(void){
        [self.streamingManager didEndTouchDrawingView];
    });
}

#pragma mark - UIPageViewControllerDataSource
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

- (void)gotoPage:(NSUInteger)pageNum
{
    SSSlideShowViewController *curentViewController = [self viewControllerAtIndex:pageNum];
    NSArray *viewControllers = [NSArray arrayWithObject:curentViewController];
    
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

#pragma mark - UIPageViewController delegate
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (completed) {
        SSSlideShowViewController *currentViewController = [[pageViewController viewControllers] lastObject];
        NSUInteger pageNum = currentViewController.pageIndex;
        [self.streamingManager gotoPageWithNum:pageNum];
    }
}

#pragma mark - private
- (SSSlideShowViewController *)viewControllerAtIndex:(NSUInteger)index
{
    SSSlideShowViewController *slideShowViewController = [[SSSlideShowViewController alloc] initWithCurrentSlideshow:self.currentSlide pageIndex:index andDelegate:self];
    return slideShowViewController;
}

@end
