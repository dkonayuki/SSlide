//
//  SSUserViewController.m
//  SSlide
//
//  Created by iNghia on 8/21/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import "SSUserViewController.h"
#import "SSUserView.h"
#import "SSSettingsViewController.h"
#import <UIViewController+MJPopupViewController.h>
#import "SSApi.h"
#import "SSAppData.h"
#import "SSSlideShowPageViewController.h"

@interface SSUserViewController () <SSUserViewDelegate, SSSlideListViewDelegate, SSSlideShowPageViewControllerDelegate, SSSettingsViewControllerDelegate>

@property (strong, nonatomic) SSUserView *myView;
@property (strong, nonatomic) NSMutableArray *slideArray;
@property (assign, nonatomic) BOOL isDownloadedMode;
@property (assign, nonatomic) NSInteger currentPage;
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
    
    self.currentPage = 1;
    self.endOfSlidesList = NO;
    
    self.isDownloadedMode = YES;
    [self getDownloadedSlideshows];
}

- (void)showSettingsView
{
    if (!self.settingsViewController) {
        self.settingsViewController = [[SSSettingsViewController alloc] initWithDelegate:self];
    }
    [self presentPopupViewController:self.settingsViewController animationType:MJPopupViewAnimationSlideLeftLeft];
}

#pragma mark - SSUserViewDelegate
- (void)segmentedControlChangedDel:(NSUInteger)index
{
    if (index == 0) {
        self.isDownloadedMode = YES;
        [self getDownloadedSlideshows];
    } else {
        self.isDownloadedMode = NO;
        self.currentPage = 1;
        self.slideArray = [[NSMutableArray alloc] init];
        [self.myView.slideListView reloadRowsWithAnimation];
        [self getUserSlideshows];
    }
}

- (NSString *)getUsernameDel
{
    return [SSAppData sharedInstance].currentUser.username;
}

#pragma mark - SSSlideListView delegate
- (NSInteger)numberOfRows
{
    return self.slideArray.count;
}

- (SSSlideshow *)getDataAtIndex:(int)index
{
    return [self.slideArray objectAtIndex:index];
}

- (void)getMoreSlides
{
    if (self.isDownloadedMode || self.endOfSlidesList) {
        return;
    }
    self.currentPage ++;
    [self getUserSlideshows];
}

- (void)didSelectedAtIndex:(int)index
{
    SSSlideshow *selectedSlide = [self.slideArray objectAtIndex:index];
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
                                           page:self.currentPage
                                        success:^(NSArray *result){
                                            if (!self.isDownloadedMode) {
                                                [self.slideArray addObjectsFromArray:result];
                                                
                                                NSUInteger slidesPerPage = [[SSDB5 theme] integerForKey:@"slide_num_in_page"];
                                                NSUInteger from = (self.currentPage -1) * slidesPerPage;
                                                NSUInteger sum = result.count;
                                                [self.myView.slideListView addRowsWithAnimation:from andSum:sum];
                                                if ([result count] < slidesPerPage){
                                                    self.endOfSlidesList = YES;
                                                } else {
                                                    self.currentPage ++;
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
    self.slideArray = [[SSAppData sharedInstance] downloadedSlides];
    [self.myView.slideListView reloadRowsWithAnimation];
}

@end
