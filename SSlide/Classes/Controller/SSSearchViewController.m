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
#import <UIViewController+MJPopupViewController.h>
#import "SSSlideShowPageViewController.h"

@interface SSSearchViewController () <SSSearchViewDelegate, SSSlideListViewDelegate, SSSlideShowPageViewControllerDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) SSSearchView *myView;
@property (strong, nonatomic) NSMutableArray *slideArray;
@property (assign, nonatomic) NSInteger currentPage;
@property (nonatomic) NSMutableString *currentText;
@property (strong, nonatomic) SSSlideShowPageViewController *pageViewController;

@end

@implementation SSSearchViewController

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
    self.myView = [[SSSearchView alloc] initWithFrame:self.view.bounds andDelegate:self];
    self.view = self.myView;
    self.slideArray = [[NSMutableArray alloc] init];
    self.currentPage = 1;
    self.currentText = [NSMutableString stringWithString:@""];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getMoreSlides:(void (^)(void))completed
{
    self.currentPage ++;
    [self searchText:self.currentText firstTime:FALSE completion:completed];
}

- (void)searchText:(NSString *)text firstTime:(BOOL)fTime completion:(void (^)(void))completed
{
    BOOL isSame = TRUE;
    if (![self.currentText isEqualToString:text] || fTime)
    {
        isSame = FALSE;
        self.currentText = [NSMutableString stringWithString:text];
        self.currentPage = 1;
    }
    [self.myView moveToTop];
    
    if (fTime) {
        [SVProgressHUD showWithStatus:@"Loading"];
    }
    
    if ([text hasPrefix:@"#"]) {
        NSString *searchText = [text substringFromIndex:1];
        NSString *requestUrl = [NSString stringWithFormat:@"%@/streaming/search?username=%@", [[SSDB5 theme] stringForKey:@"SS_SERVER_BASE_URL"], searchText];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestUrl]];
        
        AFJSONRequestOperation *operation =
        [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                        success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                            [SVProgressHUD dismiss];
                                                            [self.slideArray removeAllObjects];
                                                            NSArray *array = (NSArray *)JSON;
                                                            NSLog(@"result: %d", [array count]);
                                                            
                                                            for (NSDictionary *result in array) {
                                                                SSSlideshow *slideshow = [[SSSlideshow alloc] initWithDefaultData];
                                                                NSLog(@"%@", result);
                                                                
                                                                slideshow.username = [result objectForKey:@"username"];
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
                                                                
                                                                [self.slideArray addObject:slideshow];
                                                            }
                                                            [self.myView.slideListView.slideTableView setContentOffset:CGPointZero animated:NO];
                                                            [self.myView initSlideListView];
                                                            [self.myView.slideListView.slideTableView reloadData];
                                                        }
                                                        failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                            [SVProgressHUD dismiss];
                                                            NSLog(@"Fail");
                                                        }];
        
        [operation start];
    } else {
        NSString *params = [NSString stringWithFormat:@"q=%@&page=%d&items_per_page=%d&sort=%@", text, self.currentPage, [[SSDB5 theme] integerForKey:@"slide_num_in_page"], @"mostviewed"];
        [[SSApi sharedInstance] searchSlideshows:params
                                         success:^(NSArray *result){
                                             [SVProgressHUD dismiss];
                                             if (!isSame)
                                             {
                                                 [self.slideArray removeAllObjects];
                                                 [self.myView.slideListView.slideTableView setContentOffset:CGPointZero animated:NO];
                                             }
                                             [self.slideArray addObjectsFromArray:result];
                                             [self.myView initSlideListView];
                                             [self.myView.slideListView.slideTableView reloadData];
                                             completed();
                                         }
                                         failure:^(void) {     // TODO: error handling
                                             NSLog(@"search ERROR");
                                             [SVProgressHUD dismiss];
                                             completed();
                                         }];
    }
}

- (void) reloadSlidesListDel
{
    [self.myView.slideListView.slideTableView reloadData];
}

- (void)closePopupDel
{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    
}

- (void)didSelectedAtIndex:(int)index
{
    SSSlideshow *selectedSlide = [self.slideArray objectAtIndex:index];
    self.pageViewController = [[SSSlideShowPageViewController alloc] initWithSlideshow:selectedSlide andDelegate:self];
    [self presentPopupViewController:self.pageViewController animationType:MJPopupViewAnimationFade];
}

- (NSInteger)numberOfRows
{
    return self.slideArray.count;
}

- (SSSlideshow *)getDataAtIndex:(int)index
{
    return [self.slideArray objectAtIndex:index];
}


@end
