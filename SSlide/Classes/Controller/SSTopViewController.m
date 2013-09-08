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
#import "SSSlideShowPageViewController.h"
#import <UIViewController+MJPopupViewController.h>

@interface SSTopViewController () <SSSlideListViewDelegate, SSSlideShowPageViewControllerDelegate>

@property (strong, nonatomic) SSTopView *myView;
@property (strong, nonatomic) NSMutableArray *slideArray;
@property (assign, nonatomic) NSInteger currentPage;

@property (strong, nonatomic) SSSlideShowPageViewController *pageViewController;

@end

@implementation SSTopViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.currentPage = 1;
    self.myView = [[SSTopView alloc] initWithFrame:self.view.bounds andDelegate:self];
    self.view = self.myView;
    // init slideArray
    self.slideArray = [[NSMutableArray alloc] init];
    // show loading
    [SVProgressHUD showWithStatus:@"Loading"];
    // get first slide
    [self getTopSlideshows:^(void) {
    }];
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

- (void)getMoreSlides:(void (^)(void))completed
{
    self.currentPage ++;
    [self getTopSlideshows:completed];
}

- (void)didSelectedAtIndex:(int)index
{
    SSSlideshow *selectedSlide = [self.slideArray objectAtIndex:index];
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

#pragma mark - private
- (void)getTopSlideshows:(void (^)(void))completed
{
    NSMutableArray *tags = [NSMutableArray arrayWithArray:[SSAppData sharedInstance].currentUser.tags];
    if ([tags count] == 0) {
        [tags addObject:[[SSDB5 theme] stringForKey:@"default_tag"]];
    }
    
    int slideNumPerPage = [[SSDB5 theme] integerForKey:@"slide_num_in_page"];
    [[SSApi sharedInstance] getLatestSlideshows:tags
                                           page:self.currentPage
                                   itemsPerPage:slideNumPerPage
                                        success:^(NSArray *result) {
                                            [SVProgressHUD dismiss];
                                            [self.slideArray addObjectsFromArray:result];
                                            NSUInteger from = (self.currentPage - 1) * slideNumPerPage;
                                            NSUInteger sum = result.count;
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
