//
//  SSSlideShowPageViewController.m
//  SSlide
//
//  Created by iNghia on 8/23/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import "SSSlideShowPageViewController.h"
#import "SSSlideShowControlView.h"
#import "FayeClient.h"
#import "SSAppData.h"
#import "SSApi.h"
#import <AFNetworking/AFHTTPClient.h>

@interface SSSlideShowPageViewController () <SSSlideSHowViewControllerDelegate, SSSlideShowControlViewDelegate, FayeClientDelegate>

@property (strong, nonatomic) SSSlideshow *currentSlide;
@property (assign, nonatomic) NSInteger totalPage;
@property (strong, nonatomic) SSSlideShowControlView *controlView;
@property (strong, nonatomic) FayeClient *fayeClient;
@property (strong, nonatomic) NSString *channel;
@property (assign, nonatomic) BOOL isMaster;
@property (assign, nonatomic) BOOL isStreaming;

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
        if (self.currentSlide.channel) {
            self.channel = self.currentSlide.channel;
            self.isMaster = NO;
        }else {
            self.isMaster = YES;
        }
        self.isStreaming = NO;
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
    
    [self.currentSlide log];
    
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
    
    // control view
    float cW = IS_IPAD ? [[SSDB5 theme] floatForKey:@"slide_control_view_height_ipad"] : [[SSDB5 theme] floatForKey:@"slide_control_view_height_iphone"];
    CGRect rect = CGRectMake(self.view.bounds.size.width - cW, 0, self.view.bounds.size.height, cW);
    self.controlView = [[SSSlideShowControlView alloc] initWithFrame:rect andDelegate:self];
    self.controlView.transform = CGAffineTransformMakeRotation(M_PI_2);
    self.controlView.center = CGPointMake(self.view.bounds.size.width + cW/2, self.view.center.y);
    [self.view addSubview:self.controlView];
}

- (void)startStreaming 
{
    // checklogin
    if (![[SSAppData sharedInstance] isLogined]) {
        [SVProgressHUD showErrorWithStatus:@"Please login!"];
        return;
    }
    
    NSString *curUsername = [SSAppData sharedInstance].currentUser.username;
    self.channel = [NSString stringWithFormat:@"/%@/%@", curUsername, self.currentSlide.slideId];
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[[SSDB5 theme] stringForKey:@"SS_SERVER_BASE_URL"]]];
    [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [client setDefaultHeader:@"Accept" value:@"application/json"];
    
    NSString *url = [NSString stringWithFormat:@"streaming/create"];
    NSDictionary *params = @{@"username": curUsername,
                             @"channel": self.channel,
                             @"title": self.currentSlide.title,
                             @"thumbnailUrl": self.currentSlide.thumbnailUrl,
                             @"created": self.currentSlide.created,
                             @"numViews": [NSNumber numberWithInt:self.currentSlide.numViews],
                             @"numDownloads": [NSNumber numberWithInt:self.currentSlide.numDownloads],
                             @"numFavorites": [NSNumber numberWithInt:self.currentSlide.numFavorites],
                             @"totalSlides": [NSNumber numberWithInt:self.currentSlide.totalSlides],
                             @"slideImageBaseurl": self.currentSlide.slideImageBaseurl,
                             @"slideImageBaseurlSuffix": self.currentSlide.slideImageBaseurlSuffix,
                             @"firstPageImageUrl": self.currentSlide.firstPageImageUrl};
    
    [client postPath:url
          parameters:params
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 NSDictionary *dict = (NSDictionary *)responseObject;
                 NSLog(@"%@", dict);
                 [self startFaye];
             }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 NSLog(@"error");
             }];
}

- (void)startFaye
{
    self.fayeClient = [[FayeClient alloc] initWithURLString:[[SSDB5 theme] stringForKey:@"FAYE_BASE_URL"] channel:self.channel];
    self.fayeClient.delegate = self;
    [self.fayeClient connectToServer];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (!self.isStreaming) {
        return;
    }
    
    [self.fayeClient disconnectFromServer];
    
    if (self.isMaster) {
        NSString *curUsername = [SSAppData sharedInstance].currentUser.username;
        
        AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[[SSDB5 theme] stringForKey:@"SS_SERVER_BASE_URL"]]];
        [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [client setDefaultHeader:@"Accept" value:@"application/json"];
        
        NSString *url = [NSString stringWithFormat:@"streaming/remove"];
        NSDictionary *params = @{@"username": curUsername,
                                 @"channel": self.channel};
        
        [client postPath:url
              parameters:params
                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                     NSDictionary *dict = (NSDictionary *)responseObject;
                     NSLog(@"%@", dict);
                 }
                 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                     NSLog(@"error");
                 }];
    }
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

- (void)gotoPage:(int)pageNum
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
        int pageNum = currentViewController.pageIndex;
        NSLog(@"new page: %d", pageNum);
        NSNumber *pn = [NSNumber numberWithInt:pageNum];
        
        if (self.isMaster && self.isStreaming) {
            SSUser *currentUser = [[SSAppData sharedInstance] currentUser];
            NSDictionary *mesg = @{@"username": currentUser.username,
                                   @"pagenum": pn};
            [self.fayeClient sendMessage:mesg onChannel:self.channel];
        }
    }
}

#pragma mark - SSSlideShowViewControllerDelegate
- (void)closePopup
{
    [self.delegate closePopup];
}

- (BOOL)isMasterDel
{
    return self.isMaster;
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
    if (![self.currentSlide checkIsDownloaded]) {
        [self.currentSlide download:^(float percent) {
            NSLog(@"download: %f", percent);
            [self.controlView setDownloadProgress:percent];
        } completion:^(BOOL result){
            [SVProgressHUD showSuccessWithStatus:@"OK"];
            [self.controlView setFinishDownload];
        }];
    } else {
        [SVProgressHUD showErrorWithStatus:@"Already exists!"];
    }
}

- (void)startStreamingCurrentSlideDel
{
    if (!self.isMaster) {
        [self startFaye];
    } else {
        [self startStreaming];
    }
}

#pragma mark - Faye Client Delegate
- (void)connectedToServer
{
    NSLog(@"Connected to server");
    NSString *mes = self.isMaster ? @"Publish: OK" : @"Subscribe: OK";
    self.isStreaming = YES;
    [SVProgressHUD showSuccessWithStatus:mes];
}

- (void)disconnectedFromServer
{
    NSLog(@"Disconnected from server");
    [SVProgressHUD showErrorWithStatus:@"Disconnected"];
}

- (void)subscriptionFailedWithError:(NSString *)error
{
    NSLog(@"Subscription did fail: %@", error);
}

- (void)subscribedToChannel:(NSString *)channel
{
    NSLog(@"Subscribed to channel: %@", channel);
}

- (void)messageReceived:(NSDictionary *)messageDict channel:(NSString *)channel
{
    NSLog(@"messageReceived %@ channel %@",messageDict, channel);
    NSString *username = [messageDict objectForKey:@"username"];
    NSString *curUsername = [SSAppData sharedInstance].currentUser.username;
    if (![username isEqualToString:curUsername]) {
        int pageNum = [((NSNumber *)[messageDict objectForKey:@"pagenum"]) intValue];
        [self gotoPage:pageNum];
    }
}

- (void)connectionFailed
{
    NSLog(@"Connection Failed");
}

- (void)didSubscribeToChannel:(NSString *)channel
{
    NSLog(@"didSubscribeToChannel %@", channel);
}

- (void)didUnsubscribeFromChannel:(NSString *)channel
{
    NSLog(@"didUnsubscribeFromChannel %@", channel);
}

- (void)fayeClientError:(NSError *)error
{
    NSLog(@"fayeClientError %@", error);
}

@end
