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
#import "SSQuestionNotificationView.h"
#import "SSQuestionListViewController.h"
#import "SSSlidePageCacheManager.h"

@interface SSSlideShowPageViewController () <SSSlideSHowViewControllerDelegate, SSSlideShowControlViewDelegate, SSStreamingManagerDelegate, SSDrawingViewDelegate, SSQuestionNotificationViewDelegate>

@property (strong, nonatomic) SSSlideshow *currentSlide;
@property (assign, nonatomic) NSInteger totalPage;
@property (assign, nonatomic) NSUInteger curPageNum;
@property (strong, nonatomic) SSSlideShowControlView *controlView;
@property (strong, nonatomic) SSSlideShowInfoView *infoView;
@property (strong, nonatomic) SSStreamingManager *streamingManager;
@property (strong, nonatomic) SSDrawingView *drawingView;
@property (strong, nonatomic) FUIAlertView *alertView;
@property (assign, nonatomic) BOOL changedDrawingViewSize;
@property (strong, nonatomic) NSMutableDictionary *drawingImages;

@property (strong, nonatomic) SSQuestionNotificationView *questionNotificationView;
@property (strong, nonatomic) UIPopoverController *myPopoverController;

@property (strong, nonatomic) SSSlidePageCacheManager *slideCacheManager;

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
        self.changedDrawingViewSize = NO;
        
        // drawing images
        self.drawingImages = [[NSMutableDictionary alloc] init];
        
        self.slideCacheManager = [[SSSlidePageCacheManager alloc] initWithCurrentSlideshow:self.currentSlide delegate:self  ];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];

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
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
}

#pragma mark - private
- (void)initViewController
{
    self.curPageNum = 1;
    SSSlideShowViewController *initialViewController = [self.slideCacheManager viewControllerAtIndex:self.curPageNum];
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
    
    // question view
    float qw = 50.f;
    float left_margin = 10.f;
    float top_margin = 30.f;
    self.questionNotificationView = [[SSQuestionNotificationView alloc] initWithFrame:CGRectMake(0, 0, qw, qw) andDelegate:self];
    [self.questionNotificationView setNotificationViewHeight:self.view.bounds.size.width];
    self.questionNotificationView.backgroundColor = [UIColor clearColor];
    self.questionNotificationView.transform = CGAffineTransformMakeRotation(M_PI_2);
    self.questionNotificationView.center = CGPointMake(self.view.bounds.size.width - qw/2 - top_margin,
                                                       self.view.bounds.size.height - qw/2 - left_margin);
    [self.view addSubview:self.questionNotificationView];
    self.questionNotificationView.hidden = YES;
}

#pragma mark - SSQuestionNotificationViewDelegate
- (void)showQuestionList
{
    SSQuestionListViewController *questionViewController = [[SSQuestionListViewController alloc] init];
    [questionViewController setQuestionList:self.streamingManager.questions];
    
    self.myPopoverController = [[UIPopoverController alloc] initWithContentViewController:questionViewController];
    questionViewController.tableView.frame = CGRectMake(0, 0, 250, 600);
    self.myPopoverController.popoverContentSize = CGSizeMake(250, 600);
    [self.myPopoverController presentPopoverFromRect:self.questionNotificationView.bounds
                                              inView:self.questionNotificationView
                            permittedArrowDirections:UIPopoverArrowDirectionAny
                                            animated:YES];
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

- (void)setImageSize:(CGSize)size
{
    if (self.changedDrawingViewSize) {
        return;
    }
    
    float cw = self.drawingView.bounds.size.width;
    float ch = self.drawingView.bounds.size.height;
    float cr = cw/ch;
    float iw = size.height;
    float ih = size.width;
    float ir = iw/ih;
    
    if (cr > ir) {
        float nw = ch * ir;
        float dw = (cw - nw)/2;
        self.drawingView.frame = CGRectMake(dw, 0, nw, ch);
        [self.drawingView resetSize];
    } else if (cr < ir) {
        float nh = cw / ir;
        float dh = (ch - nh)/2;
        self.drawingView.frame = CGRectMake(0, dh, cw, nh);
        [self.drawingView resetSize];
    }
    
    self.changedDrawingViewSize = YES;
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
                         if(IS_IPHONE && SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
                             cW += 20.f;
                         }
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
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
            [self.currentSlide download:^(float percent) {
                [self.controlView setDownloadProgress:percent];
            } completion:^(BOOL result){
                [SVProgressHUD showSuccessWithStatus:@"Download completed!"];
                [self.delegate reloadSlidesListDel];
                [self.controlView setFinishDownload];
                // reload user page
                NSNotification *notification = [NSNotification notificationWithName:@"SSDownloadFinish" object:nil];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
            }];
        });
    } else {
        [SVProgressHUD showErrorWithStatus:@"Already exists!"];
    }
}

- (void)displayConnectedMessage:(NSString *)mes withTitle:(NSString *)title
{
    float fontSize = IS_IPAD ? 28.f : 14.f;
    self.alertView = [[FUIAlertView alloc] initWithTitle:title
                                                          message:mes
                                                         delegate:nil
                                                cancelButtonTitle:nil
                                                otherButtonTitles:nil, nil];
    self.alertView.titleLabel.textColor = [UIColor cloudsColor];
    self.alertView.titleLabel.font = [UIFont fontWithName:[[SSDB5 theme] stringForKey:@"candara_font"] size:fontSize * 1.2];
    self.alertView.messageLabel.textColor = [UIColor cloudsColor];
    self.alertView.messageLabel.font = [UIFont fontWithName:[[SSDB5 theme] stringForKey:@"candara_font"] size:fontSize];
    self.alertView.backgroundOverlay.backgroundColor = [UIColor clearColor];
    self.alertView.alertContainer.backgroundColor = [[SSDB5 theme] colorForKey:@"streaming_alert_bg_color"];
    //alertView.transform = CGAffineTransformMakeRotation(M_PI_2);
    [self.alertView show];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissMessage)];
    [self.alertView addGestureRecognizer:singleTap];
}

- (void)dismissMessage
{
    [self.alertView dismissWithClickedButtonIndex:0 animated:YES];
}

- (void)startStreamingCurrentSlideDel
{
    [self.streamingManager startSynchronizing];
    if ([self.streamingManager isMasterDevice]) {
        self.questionNotificationView.hidden = NO;
    }
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

- (void)sendQuestion:(NSString *)question
{
    [self.streamingManager sendQuestion:question];
}

#pragma mark - SSStreamingManagerDelegate
- (void)gotoPageWithNumDel:(NSUInteger)pageNum
{
    /*
    if (pageNum == self.curPageNum -1) {
        
    } else if (pageNum == self.curPageNum + 1) {
        
    } else {
     */
        [self gotoPage:pageNum];
    //}
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

- (void)didHasNewQuestion:(NSString *)question
{
    int quesNum = [self.streamingManager.questions count];
    [self.questionNotificationView addNewQuestion:quesNum content:question];
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
    
    return [self.slideCacheManager viewControllerAtIndex:index];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [(SSSlideShowViewController *)viewController pageIndex];
    index ++;
    if (index == self.totalPage + 1) {
        return nil;
    }
    
    return  [self.slideCacheManager viewControllerAtIndex:index];
}

- (void)gotoPage:(NSUInteger)pageNum
{
    UIImage *preImage = [self.drawingView getCopyDrawingImage];
    if(preImage) {
        [self.drawingImages setObject:preImage forKey:[NSNumber numberWithInt:self.curPageNum]];
    }
    self.curPageNum = pageNum;
    [self.infoView setPageNumber:self.curPageNum];
    
    // reset drawing
    UIImage *curImage = [self.drawingImages objectForKey:[NSNumber numberWithInt:self.curPageNum]];
    [self.drawingView resetWithImage:curImage];
    
    SSSlideShowViewController *curentViewController = [self.slideCacheManager viewControllerAtIndex:self.curPageNum];
    NSArray *viewControllers = [NSArray arrayWithObject:curentViewController];
    
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

#pragma mark - UIPageViewController delegate
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (completed) {
        // save drawing image
        UIImage *preImage = [self.drawingView getCopyDrawingImage];
        if(preImage) {
            [self.drawingImages setObject:preImage forKey:[NSNumber numberWithInt:self.curPageNum]];
        }
        
        // change
        SSSlideShowViewController *currentViewController = [[pageViewController viewControllers] lastObject];
        self.curPageNum = currentViewController.pageIndex;
        
        // reset drawing
        UIImage *curImage = [self.drawingImages objectForKey:[NSNumber numberWithInt:self.curPageNum]];
        [self.drawingView resetWithImage:curImage];
        
        [self.streamingManager gotoPageWithNum:self.curPageNum];
        // set page num
        [self.infoView setPageNumber:self.curPageNum];
    }
}

@end
