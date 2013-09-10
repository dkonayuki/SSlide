//
//  SSSearchViewController.m
//  SSlide
//
//  Created by iNghia on 8/21/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import "SSSearchViewController.h"
#import "SSSearchView.h"
#import "SSApi.h"
#import "SSSlideshow.h"
#import "SSSlideDataSource.h"
#import <UIViewController+MJPopupViewController.h>
#import "SSSlideShowPageViewController.h"
#import "SSDescriptionViewController.h"

@interface SSSearchViewController () <SSSearchViewDelegate, SSSlideListViewDelegate, SSSlideShowPageViewControllerDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) SSSearchView *myView;
@property (strong, nonatomic) SSSlideDataSource *slideDataSource;
@property (copy, nonatomic) NSString *currentSearchKeyword;
@property (strong, nonatomic) SSSlideShowPageViewController *pageViewController;
@property (strong, nonatomic) SSDescriptionViewController *descriptionViewController;

@end

@implementation SSSearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.myView = [[SSSearchView alloc] initWithFrame:self.view.bounds andDelegate:self];
    self.view = self.myView;
    self.slideDataSource = [[SSSlideDataSource alloc] init];
    self.currentSearchKeyword = @"";
}

- (void)showDescriptionView
{
    if (!self.descriptionViewController) {
        self.descriptionViewController = [[SSDescriptionViewController alloc] init];
    }
    [self presentPopupViewController:self.descriptionViewController animationType:MJPopupViewAnimationSlideRightRight];
}

#pragma mark - SSSlideListView delegate
- (void)getMoreSlides:(void (^)(void))completed
{
    [self searchText:self.currentSearchKeyword firstTime:FALSE completion:completed];
}

- (void)didSelectedAtIndex:(int)index
{
    [self.view endEditing:YES];
    SSSlideshow *selectedSlide = [self.slideDataSource slideAtIndex:index];
    self.pageViewController = [[SSSlideShowPageViewController alloc] initWithSlideshow:selectedSlide andDelegate:self];
    [self presentPopupViewController:self.pageViewController animationType:MJPopupViewAnimationFade];
}

- (NSInteger)numberOfRows
{
    return [self.slideDataSource slideSum];
}

- (SSSlideshow *)getDataAtIndex:(int)index
{
    return [self.slideDataSource slideAtIndex:index];
}

#pragma mark - SSSlidePageViewController delegate
- (void) reloadSlidesListDel
{
    [self.myView.slideListView reloadRowsWithAnimation];
}

- (void)closePopupDel
{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}

#pragma mark - private
- (void)searchText:(NSString *)text firstTime:(BOOL)fTime completion:(void (^)(void))completed
{
    BOOL isSame = TRUE;
    if (![self.currentSearchKeyword isEqualToString:text] || fTime) {
        isSame = FALSE;
        self.currentSearchKeyword = text;
        [self.slideDataSource resetDataSource];
    }
    
    if (fTime) {
        [SVProgressHUD showWithStatus:@"Loading"];
        [self.myView moveToTop];
    }
    
    if ([text hasPrefix:@"#"]) {
        NSString *username = [text substringFromIndex:1];
        [self searchStreaming:username completion:completed];
    } else {
        int slidesPerPage = [[SSDB5 theme] integerForKey:@"slide_num_in_page"];
        int currentPageNum = [self.slideDataSource currentPageNum];
        NSString *params = [NSString stringWithFormat:@"q=%@&page=%d&items_per_page=%d", text, currentPageNum, slidesPerPage];
        [[SSApi sharedInstance] searchSlideshows:params
                                         success:^(NSArray *result){
                                             [SVProgressHUD dismiss];
                                             
                                             NSUInteger from = [self.slideDataSource slideSum];
                                             NSUInteger sum = result.count;

                                             [self.slideDataSource addSlidesFromArray:result];
                                             [self.myView initSlideListView];
                                             
                                             if (fTime) {
                                                 [self.myView.slideListView reloadRowsWithAnimation];
                                             } else {
                                                 [self.myView.slideListView addRowsWithAnimation:from andSum:sum];
                                             }
                                             completed();
                                         }
                                         failure:^(void) {     // TODO: error handling
                                             NSLog(@"search ERROR");
                                             [SVProgressHUD dismiss];
                                             completed();
                                         }];
    }
}

- (void)searchStreaming:(NSString *)username completion:(void (^)(void))completed {
    NSString *requestUrl = [NSString stringWithFormat:@"%@/streaming/search?username=%@", [[SSDB5 theme] stringForKey:@"SS_SERVER_BASE_URL"], username];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestUrl]];
    
    AFJSONRequestOperation *operation =
    [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                    success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                        [SVProgressHUD dismiss];
                                                        [self.slideDataSource resetDataSource];
                                                        NSArray *array = (NSArray *)JSON;
                                                        NSLog(@"result: %d", [array count]);
                                                        
                                                        for (NSDictionary *result in array) {
                                                            SSSlideshow *slideshow = [[SSSlideshow alloc] initWithDefaultData];
                                                            
                                                            slideshow.username = [result objectForKey:@"username"];
                                                            slideshow.slideId = [result objectForKey:@"slideId"];
                                                            slideshow.title = [result objectForKey:@"title"];
                                                            [slideshow setNormalThumbnailUrl:[result objectForKey:@"thumbnailUrl"]];
                                                            [slideshow setNormalCreated:[result objectForKey:@"created"]];
                                                            slideshow.numViews = [((NSNumber *)[result objectForKey:@"numViews"]) intValue];
                                                            slideshow.numDownloads = [((NSNumber *)[result objectForKey:@"numDownloads"]) intValue];
                                                            slideshow.numFavorites = [((NSNumber *)[result objectForKey:@"numFavarites"]) intValue];
                                                            slideshow.totalSlides = [((NSNumber *)[result objectForKey:@"totalSlides"]) intValue];
                                                            [slideshow setNormalSlideImageBaseurl:[result objectForKey:@"slideImageBaseurl"]];
                                                            slideshow.slideImageBaseurlSuffix = [result objectForKey:@"slideImageBaseurlSuffix"];
                                                            slideshow.firstPageImageUrl = [result objectForKey:@"firstPageImageUrl"];
                                                            slideshow.channel = [result objectForKey:@"channel"];
                                                            
                                                            [self.slideDataSource addSlide:slideshow];
                                                        }
                                                        [self.myView.slideListView.slideTableView setContentOffset:CGPointZero animated:NO];
                                                        [self.myView initSlideListView];
                                                        [self.myView.slideListView reloadRowsWithAnimation];
                                                    }
                                                    failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                        [SVProgressHUD dismiss];
                                                        NSLog(@"Fail");
                                                    }];
    
    [operation start];
}

@end
