//
//  SSUserViewController.m
//  SSlide
//
//  Created by iNghia on 8/21/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import "SSUserViewController.h"
#import "SSUserView.h"
#import "SSApi.h"
#import "SSAppData.h"
#import "SSSlideDataSource.h"
#import "SSSlideShowPageViewController.h"
#import "SSSettingsViewController.h"
#import <UIViewController+MJPopupViewController.h>

@interface SSUserViewController () <SSUserViewDelegate,
                                    SSSlideListViewDelegate,
                                    SSSlideShowPageViewControllerDelegate,
                                    SSSettingsViewControllerDelegate>

@property (strong, nonatomic) SSUserView *myView;
@property (strong, nonatomic) SSSlideDataSource *slideDataSource;
@property (assign, nonatomic) BOOL isDownloadedMode;
@property (assign, nonatomic) BOOL endOfSlidesList;
@property (strong, nonatomic) SSSlideShowPageViewController *pageViewController;
@property (strong, nonatomic) SSSettingsViewController *settingsViewController;

@end

@implementation SSUserViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.myView = [[SSUserView alloc] initWithFrame:self.view.bounds andDelegate:self];
    self.view = self.myView;
    
    self.endOfSlidesList = NO;
    self.isDownloadedMode = YES;
    
    self.slideDataSource = [[SSSlideDataSource alloc] init];
    
    [self getDownloadedSlideshows];
    
    // add tag change notification
    NSNotificationCenter *ncenter = [NSNotificationCenter defaultCenter];
    [ncenter addObserver:self selector:@selector(SSDownloadFinishNotification:) name:@"SSDownloadFinish" object:nil];
}

- (void)showSettingsView
{
    if (!self.settingsViewController) {
        self.settingsViewController = [[SSSettingsViewController alloc] initWithDelegate:self];
    }
    [self presentPopupViewController:self.settingsViewController animationType:MJPopupViewAnimationSlideLeftLeft];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - notification
- (void)SSDownloadFinishNotification:(NSNotification *)center
{
    if (self.isDownloadedMode) {
        [self getDownloadedSlideshows];
    }
}

#pragma mark - SSUserViewDelegate
- (void)segmentedControlChangedDel:(NSUInteger)index
{
    if (index == 0) {
        self.isDownloadedMode = YES;
        [self getDownloadedSlideshows];
    } else {
        self.isDownloadedMode = NO;
        [self.slideDataSource resetDataSource];
        [self.myView.slideListView reloadRowsWithAnimation];
        [self getUserSlideshows];
    }
}

- (NSString *)getUsernameDel
{
    return [SSAppData sharedInstance].currentUser.username;
}

- (void)deleteDownloadedSlideAtIndex:(NSUInteger)index
{
    BOOL result = [[SSAppData sharedInstance] deleteDownloadedSlideAtIndex:index];
    if (result) {
        [self getDownloadedSlideshows];
        [SVProgressHUD showSuccessWithStatus:@"Deleted!"];
    } else {
        [SVProgressHUD showErrorWithStatus:@"Error!"];
    }
}

#pragma mark - SSSlideListView delegate
- (NSInteger)numberOfRows
{
    return [self.slideDataSource slideSum];
}

- (SSSlideshow *)getDataAtIndex:(int)index
{
    return [self.slideDataSource slideAtIndex:index];
}

- (void)getMoreSlides
{
    if (self.isDownloadedMode || self.endOfSlidesList) {
        return;
    }
    [self getUserSlideshows];
}

- (void)didSelectedAtIndex:(int)index
{
    SSSlideshow *selectedSlide = [self.slideDataSource slideAtIndex:index];
    self.pageViewController = [[SSSlideShowPageViewController alloc] initWithSlideshow:selectedSlide andDelegate:self];
    [self presentPopupViewController:self.pageViewController animationType:MJPopupViewAnimationFade];
}

#pragma mark - SSlideShowPageViewController delegate
- (void) reloadSlidesListDel
{
    [self.myView.slideListView reloadRowsWithAnimation];
}

- (void)closePopupDel
{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}

#pragma mark - SSSetingsViewController delegate
- (void)reloadSettingsDataDel
{
    [self.myView refresh];
}

#pragma mark - private
- (void)getUserSlideshows
{
    if (![[SSAppData sharedInstance] isLogined]) {
        return;
    }
    // show loading
    [SVProgressHUD showWithStatus:@"Loading"];
    // TODO: get setting info
    NSString *currentUsername = [SSAppData sharedInstance].currentUser.username;
    [[SSApi sharedInstance] getSlideshowsByUser:currentUsername
                                           page:[self.slideDataSource currentPageNum]
                                        success:^(NSArray *result){
                                            if (!self.isDownloadedMode) {
                                                
                                                NSUInteger from = [self.slideDataSource slideSum];
                                                NSUInteger sum = result.count;
                        
                                                [self.slideDataSource addSlidesFromArray:result];
                                                [self.myView.slideListView addRowsWithAnimation:from andSum:sum];
                                                
                                                int slidesPerPage = [[SSDB5 theme] integerForKey:@"slide_num_in_page"];
                                                if ([result count] < slidesPerPage){
                                                    self.endOfSlidesList = YES;
                                                }
                                            }
                                            [SVProgressHUD dismiss];
                                        }
                                        failure:^(void) {     // TODO: error handling
                                            NSLog(@"search ERROR");
                                        }];
}

- (void)getDownloadedSlideshows
{
    [self.slideDataSource resetBySlideArray:[[SSAppData sharedInstance] downloadedSlides]];
    [self.myView.slideListView reloadRowsWithAnimation];
}

@end
