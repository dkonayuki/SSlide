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
#import "SSQuestionNotificationView.h"
#import "SSQuestionListViewController.h"
#import "SSSlidePageCacheManager.h"
#import "SSSlideShowPageView.h"
#import "SSSlideShowControlView.h"
#import "SSSlideShowInfoView.h"
#import "SSStreamingManager.h"
#import "SSDrawingView.h"

@interface SSSlideShowPageViewController () <SSSlideShowViewControllerDelegate,
                                            SSSlideShowControlViewDelegate,
                                            SSStreamingManagerDelegate,
                                            SSDrawingViewDelegate,
                                            SSQuestionNotificationViewDelegate,
                                            SSQuestionListViewControllerDelegate>

@property (strong, nonatomic) SSSlideshow *currentSlide;
@property (assign, nonatomic) NSInteger totalPage;
@property (assign, nonatomic) NSUInteger curPageNum;

@property (assign, nonatomic) BOOL changedDrawingViewSize;
@property (strong, nonatomic) NSMutableDictionary *drawingImages;

@property (strong, nonatomic) SSStreamingManager *streamingManager;
@property (strong, nonatomic) SSSlidePageCacheManager *slideCacheManager;
@property (strong, nonatomic) SSSlideShowPageView *myView;

@property (strong, nonatomic) UIPopoverController *myPopoverController;

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
        // slide cache manager
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
    [self.myView offStreamingBtn];
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationSlide];
}

#pragma mark - private
- (void)initViewController
{
    self.myView = [[SSSlideShowPageView alloc] initWithFrame:self.view.bounds andDelegate:self];
    [self.myView initSubView:self.currentSlide.title totalPage:self.totalPage];
    self.view = self.myView;
    
    self.curPageNum = 1;
    SSSlideShowViewController *initialViewController = [self.slideCacheManager viewControllerAtIndex:self.curPageNum];
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    [self addChildViewController:self.pageController];
    [self.myView addSubview:self.pageController.view];
    [self.pageController didMoveToParentViewController:self];
    
    [self.myView bringAllSubViewToFront];
}

#pragma mark - SSQuestionNotificationViewDelegate
- (void)showQuestionList
{
    SSQuestionListViewController *questionViewController = [[SSQuestionListViewController alloc] init];
    [questionViewController setQuestionList:self.streamingManager.questions];
    questionViewController.delegate = self;
    
    if(IS_IPAD) {
        self.myPopoverController = [[UIPopoverController alloc] initWithContentViewController:questionViewController];
        questionViewController.tableView.frame = CGRectMake(0, 0, 350, 620);
        self.myPopoverController.popoverContentSize = CGSizeMake(350, 620);
        [self.myPopoverController presentPopoverFromRect:[self.myView getQuestionNotificationView].bounds
                                                  inView:[self.myView getQuestionNotificationView]
                                permittedArrowDirections:UIPopoverArrowDirectionAny
                                                animated:YES];
    } else {
        [SVProgressHUD showErrorWithStatus:@"Only supported on iPad"];
    }
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

- (BOOL)isStreamingAsClient
{
    return [self.streamingManager isStreamingAsClient];
}

- (void)toogleInfoView
{
    [self.myView toogleInfoView];
}

- (void)showControlView
{
    [self.myView showControlView];
}

- (void)hideControlView
{
    [self.myView hideControlView];
}

- (void)setImageSize:(CGSize)size
{
    if (self.changedDrawingViewSize) {
        return;
    }
    
    [self.myView setDrawingViewSize:size];
    self.changedDrawingViewSize = YES;
}

- (void)downloadCurrentSlideDel
{
    if (![self.currentSlide checkIsDownloadedAsNew]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
            [self.currentSlide download:^(float percent) {
                [self.myView showDownloadProgress:percent];
            } completion:^(BOOL result){
                [SVProgressHUD showSuccessWithStatus:@"Download completed!"];
                [self.delegate reloadSlidesListDel];
                [self.myView showDownloadFinished];
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
    if(![self.streamingManager startSynchronizing]){
        [self.myView offStreamingBtn];
        return;
    }
    if ([self.streamingManager isMasterDevice]) {
        [self.myView showQuestionNotificationView];
    }
}

- (void)stopStreamingCurrentSlideDel
{
    [self.streamingManager stopSynchronizing];
    [self.myView offStreamingBtn];
}

- (void)startDrawing
{
    [self.myView showDrawingView:YES];
}

- (void)stopDrawing
{
    [self.myView showDrawingView:NO];
}

- (void)clearDrawing
{
    [self.myView clearDrawing];
    [self.streamingManager didClearDrawingView];
}

- (BOOL)slideIdDownloaded
{
    return [self.currentSlide checkIsDownloadedAsNew];
}

- (void)sendQuestion:(NSString *)question
{
    [self.streamingManager sendQuestion:question atPage:self.curPageNum slideId:self.currentSlide.slideId];
}

#pragma mark - SSStreamingManagerDelegate
- (void)gotoPageWithNumDel:(NSUInteger)pageNum
{
    [self gotoPage:pageNum];
}

- (void)didAddPointsFromMasterDel:(NSArray *)points
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^(void) {
        [self.myView drawingNewPoinst:points];
    });
}

- (void)didClearFromMasterDel
{
    [self.myView clearDrawing];
}

- (void)disconnectedFromServerDel
{
    [self.myView offStreamingBtn];
}

- (void)didEndTouchFromMasterDel
{
    [self.myView drawingDidEnd];
}

- (void)didHasNewQuestion:(NSString *)question
{
    int quesNum = [self.streamingManager.questions count];
    [self.myView showNewQuestion:quesNum content:question];
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

#pragma mark - SSQuestionListViewController
- (void)didSelectQuestionAtPage:(int)pagenum
{
    [self gotoPage:pagenum];
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
    UIImage *preImage = [self.myView getCopyDrawingImage];
    if(preImage) {
        [self.drawingImages setObject:preImage forKey:[NSNumber numberWithInt:self.curPageNum]];
    }
    self.curPageNum = pageNum;
    [self.myView updateInforView:self.curPageNum];
    
    // reset drawing
    UIImage *curImage = [self.drawingImages objectForKey:[NSNumber numberWithInt:self.curPageNum]];
    [self.myView resetDrawingViewWithImage:curImage];
    
    SSSlideShowViewController *curentViewController = [self.slideCacheManager viewControllerAtIndex:self.curPageNum];
    NSArray *viewControllers = [NSArray arrayWithObject:curentViewController];
    
    [self.pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
}

#pragma mark - UIPageViewController delegate
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    if (completed) {
        // save drawing image
        UIImage *preImage = [self.myView getCopyDrawingImage];
        if(preImage) {
            [self.drawingImages setObject:preImage forKey:[NSNumber numberWithInt:self.curPageNum]];
        }
        
        // change
        SSSlideShowViewController *currentViewController = [[pageViewController viewControllers] lastObject];
        self.curPageNum = currentViewController.pageIndex;
        
        // reset drawing
        UIImage *curImage = [self.drawingImages objectForKey:[NSNumber numberWithInt:self.curPageNum]];
        [self.myView resetDrawingViewWithImage:curImage];
        
        [self.streamingManager gotoPageWithNum:self.curPageNum];
        // set page num
        [self.myView updateInforView:self.curPageNum];
    }
}

@end
