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

@interface SSUserViewController () <SSUserViewDelegate, SSSlideListViewDelegate>

@property (strong, nonatomic) SSUserView *myView;
@property (strong, nonatomic) NSMutableArray *slideArray;
@property (assign, nonatomic) BOOL isDownloadedMode;
@property (assign, nonatomic) NSInteger currentPage;
@property (strong, nonatomic) SSSlideShowPageViewController *pageViewController;

@end

@implementation SSUserViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.myView = [[SSUserView alloc] initWithFrame:self.view.bounds andDelegate:self];
    self.view = self.myView;
    
    self.currentPage = 1;
    self.isDownloadedMode = YES;
    [self getDownloadedSlideshows];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SSUserViewDelegate
- (void)segmentedControlChangedDel:(NSUInteger)index
{
    if (index == 0) {
        self.isDownloadedMode = YES;
        [self getDownloadedSlideshows];
    } else {
        self.isDownloadedMode = NO;
        // init slideArray
        self.slideArray = [[NSMutableArray alloc] init];
        [self getUserSlideshows];
    }
}

- (void)settingsBtnPressedDel
{
    SSSettingsViewController *settingsViewController = [[SSSettingsViewController alloc] init];
    [self presentPopupViewController:settingsViewController animationType:MJPopupViewAnimationSlideBottomBottom];
}

#pragma mark - SSTopView delegate
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
    if (self.isDownloadedMode) {
        return;
    }
    self.currentPage ++;
    [self getUserSlideshows];
}

- (void)didSelectedAtIndex:(int)index
{
    SSSlideshow *selectedSlide = [self.slideArray objectAtIndex:index];
//    if ([selectedSlide extendedInfoIsNil]) {
//        return;
//    }
    self.pageViewController = [[SSSlideShowPageViewController alloc] initWithSlideshow:selectedSlide andDelegate:self];
    [self presentPopupViewController:self.pageViewController animationType:MJPopupViewAnimationFade];
}

- (void)closePopup
{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}

#pragma mark - private
- (void)getUserSlideshows
{
    // show loading
    [SVProgressHUD showWithStatus:@"Loading"];
    // TODO: get setting info
    [[SSApi sharedInstance] getSlideshowsByUser:@"rashmi"
                                        success:^(NSArray *result){
                                            if (!self.isDownloadedMode) {
                                                self.currentPage++;
                                                [self.slideArray addObjectsFromArray:result];
                                                [self.myView.slideListView.slideTableView reloadData];
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
    [self.myView.slideListView.slideTableView reloadData];
}

@end
