//
//  SSTopViewController.m
//  SSlide
//
//  Created by iNghia on 8/21/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import "SSTopViewController.h"
#import "SSTopView.h"
#import "SSApi.h"
#import "SSAppData.h"
#import "SSSlideshow.h"
#import "SSSlideDataSource.h"
#import "SSSlideShowPageViewController.h"
#import <UIViewController+MJPopupViewController.h>

@interface SSTopViewController () <SSSlideListViewDelegate, SSSlideShowPageViewControllerDelegate>

@property (strong, nonatomic) SSTopView *myView;
@property (strong, nonatomic) SSSlideDataSource *slideDataSource;
@property (strong, nonatomic) SSSlideShowPageViewController *pageViewController;

@end

@implementation SSTopViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.myView = [[SSTopView alloc] initWithFrame:self.view.bounds andDelegate:self];
    self.view = self.myView;
    // init slideDataSource
    self.slideDataSource = [[SSSlideDataSource alloc] init];
    // show loading
    [SVProgressHUD showWithStatus:@"Loading"];
    // get first slide
    [self getTopSlideshows:^(void) {
    }];
    
    // add tag change notification
    NSNotificationCenter *ncenter = [NSNotificationCenter defaultCenter];
    [ncenter addObserver:self selector:@selector(SSDidChangeTagNotification:) name:@"SSDidChangeTag" object:nil];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    // check download tutorial
    if(![defaults objectForKey:@"DownloadedTutorialSlide"]) {
        [SVProgressHUD showWithStatus:@"Downloading"];
        [[SSApi sharedInstance] getSlideshowsById:[[SSDB5 theme] stringForKey:@"tutorial_slide_id"]
                                          success:^(SSSlideshow *slide) {
                                              [[SSApi sharedInstance] addExtendedSlideInfo:slide
                                                                                    result:^(BOOL result) {
                                                                                        [self downloadTutorialSlide:slide];
                                                                                    }];
                                          }
                                          failure:^(void) {
                                              [SVProgressHUD showErrorWithStatus:@"Error!"];
                                          }];
    }
}

- (void)downloadTutorialSlide:(SSSlideshow *)slide
{
    if (![slide checkIsDownloadedAsNew]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
            [slide download:^(float percent) {
            } completion:^(BOOL result){
                [SVProgressHUD showSuccessWithStatus:@"Download completed!"];
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:@"OK" forKey:@"DownloadedTutorialSlide"];
                [defaults synchronize];
                
                // reload user page
                NSNotification *notification = [NSNotification notificationWithName:@"SSDownloadFinish" object:nil];
                [[NSNotificationCenter defaultCenter] postNotification:notification];
            }];
        });
    } else {
        [SVProgressHUD showErrorWithStatus:@"Already exists!"];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - SSTopView delegate
- (NSInteger)numberOfRows
{
    return [self.slideDataSource slideSum];
}

- (SSSlideshow *)getDataAtIndex:(int)index
{
    return [self.slideDataSource slideAtIndex:index];
}

- (void)getMoreSlides:(void (^)(void))completed
{
    [self getTopSlideshows:completed];
}

- (void)didSelectedAtIndex:(int)index
{
    SSSlideshow *selectedSlide = [self.slideDataSource slideAtIndex:index];
    self.pageViewController = [[SSSlideShowPageViewController alloc] initWithSlideshow:selectedSlide andDelegate:self];
    [self presentPopupViewController:self.pageViewController animationType:MJPopupViewAnimationFade];
}

#pragma SSSlideShowPageViewController delegate
- (void) reloadSlidesListDel
{
    [self.myView.slideListView reloadRowsWithAnimation];
}

- (void)closePopupDel
{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}

#pragma mark - notification
- (void)SSDidChangeTagNotification:(NSNotification *)center
{
    [self.slideDataSource resetDataSource];
    [self.myView.slideListView reloadRowsWithAnimation];
    // get first slide
    [self getTopSlideshows:^(void) {
    }];
}

#pragma mark - private
- (void)getTopSlideshows:(void (^)(void))completed
{
    NSMutableArray *tags = [NSMutableArray arrayWithArray:[SSAppData sharedInstance].currentUser.tags];
    if ([tags count] == 0) {
        [tags addObject:[[SSDB5 theme] stringForKey:@"default_tag"]];
    }
    
    int slideNumPerPage = [[SSDB5 theme] integerForKey:@"slide_num_in_page"];
    [[SSApi sharedInstance] getLatestSlideshows:tags
                                           page:[self.slideDataSource nextPageNum]
                                   itemsPerPage:slideNumPerPage
                                        success:^(NSArray *result) {
                                            [SVProgressHUD dismiss];
                                            NSUInteger from = [self.slideDataSource slideSum];
                                            NSUInteger sum = result.count;
                                            [self.slideDataSource addSlidesFromArray:result];
                                            [self.myView.slideListView addRowsWithAnimation:from andSum:sum];
                                            completed();
                                        }
                                        failure:^(void) {     // TODO: error handling
                                            [SVProgressHUD dismiss];
                                            completed();
                                            NSLog(@"MostViewed ERROR");
                                        }];
}

@end
