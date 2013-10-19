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
@property (assign, nonatomic) NSUInteger searchOption;
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
    
    // keyboard
    [[NSNotificationCenter defaultCenter] addObserver:self.myView
                                             selector:@selector(keyboardWillShow:)
                                                 name:@"UIKeyboardWillShowNotification"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self.myView
                                             selector:@selector(keyboardWillHide:)
                                                 name:@"UIKeyboardWillHideNotification"
                                               object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self.myView];
}

- (void)showDescriptionView
{
    if (!self.descriptionViewController) {
        self.descriptionViewController = [[SSDescriptionViewController alloc] init];
    }
    [self presentPopupViewController:self.descriptionViewController animationType:MJPopupViewAnimationSlideRightRight];
}

#pragma mark - SSSearchView delegate
- (void)searchText:(NSString *)text option:(NSUInteger)option firstTime:(BOOL)fTime completion:(void (^)(void))completed
{
    if (![self.currentSearchKeyword isEqualToString:text] || (self.searchOption != option)) {
        self.currentSearchKeyword = text;
        self.searchOption = option;
        [self.slideDataSource resetDataSource];
    }
    
    [self.myView moveToTop];
    
    [self searchSlides:YES completion:completed];
}

#pragma mark - SSSlideListView delegate
- (void)getMoreSlides:(void (^)(void))completed
{
    [self searchSlides:NO completion:completed];
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
- (void)searchSlides:(BOOL)isFirstTime completion:(void (^)(void))completed
{
    if (isFirstTime) {
        [SVProgressHUD showWithStatus:@"loading"];
        [self.myView moveToTop];
    }
    
    if ([self.currentSearchKeyword hasPrefix:@"#"]) {
        NSString *username = [self.currentSearchKeyword substringFromIndex:1];
        [self searchStreaming:username completion:completed];
    } else {
        int slidesPerPage = [[SSDB5 theme] integerForKey:@"slide_num_in_page"];
        int currentPageNum = [self.slideDataSource currentPageNum];
        NSString *sort = @"relevance";
        switch (self.searchOption) {
            case SEARCH_OPTION_MOST_VIEWED:
                sort = @"mostviewed";
                break;
            case SEARCH_OPTION_LASTEST:
                sort = @"latest";
            default:
                break;
        }
        
        NSString *params = [NSString stringWithFormat:@"q=%@&page=%d&items_per_page=%d&sort=%@", self.currentSearchKeyword, currentPageNum, slidesPerPage, sort ];
        [[SSApi sharedInstance] searchSlideshows:params
                                         success:^(NSArray *result){
                                             [SVProgressHUD dismiss];
                                             NSUInteger from = [self.slideDataSource slideSum];
                                             NSUInteger sum = result.count;

                                             [self.slideDataSource addSlidesFromArray:result];
                                             [self.myView initSlideListView];
                                             
                                             if (isFirstTime) {
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
    NSString *requestUrl = [NSString stringWithFormat:@"%@/streaming/search?channel=/%@",
                            [[SSDB5 theme] stringForKey:@"SS_SERVER_BASE_URL"], username];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestUrl]];
    
    AFJSONRequestOperation *operation =
    [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                    success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                        [SVProgressHUD dismiss];
                                                        [self.slideDataSource resetDataSource];
                                                        NSDictionary *dic = (NSDictionary *)JSON;
                                                        NSString *messType = [dic objectForKey:@"message_type"];
                                                        
                                                        if ([messType isEqualToString:@"error"]) {
                                                            [SVProgressHUD showSuccessWithStatus:@"No Results!"];
                                                        } else {
                                                            NSArray *array = (NSArray *)[dic objectForKey:@"message_content"];
                                                            for (NSDictionary *result in array) {
                                                                SSSlideshow *slideshow = [[SSSlideshow alloc] initWithDefaultData];
                                                                [slideshow assignDataFromDictionary:result];
                                                                [self.slideDataSource addSlide:slideshow];
                                                            }
                                                        }
                                                        
                                                        [self.myView.slideListView.slideTableView setContentOffset:CGPointZero animated:NO];
                                                        [self.myView initSlideListView];
                                                        [self.myView.slideListView reloadRowsWithAnimation];
                                                    }
                                                    failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                        [SVProgressHUD dismiss];
                                                        NSLog(@"Fail: %@", error);
                                                    }];
    
    [operation start];
}

@end
