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

- (void)getMoreSlides
{
    self.currentPage ++;
    [self searchText:self.currentText firstTime:FALSE];
}

- (void)searchText:(NSString *)text firstTime:(BOOL)fTime
{
    BOOL isSame = TRUE;
    if (![self.currentText isEqualToString:text] || fTime)
    {
        isSame = FALSE;
        self.currentText = [NSMutableString stringWithString:text];
        self.currentPage = 1;
    }
    [self.myView moveToTop];

    [SVProgressHUD showWithStatus:@"Loading"];
     NSString *params = [NSString stringWithFormat:@"q=%@&page=%d&items_per_page=10", text, self.currentPage];
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
                                          
                                            /*
                                           NSLog(@"%d", [self.slideArray count]);
                                           for (SSSlideshow *cur in self.slideArray) {
                                            [cur log];
                                           }
                                           */
                                      }
                                      failure:^(void) {     // TODO: error handling
                                          NSLog(@"search ERROR");
                                          [SVProgressHUD dismiss];
                                      }];
}

- (void)closePopup
{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    
}

- (void)didSelectedAtIndex:(int)index
{
    SSSlideshow *selectedSlide = [self.slideArray objectAtIndex:index];
    if ([selectedSlide extendedInfoIsNil]) {
        return;
    }
    self.pageViewController = [[SSSlideShowPageViewController alloc] initWithSlideshow:selectedSlide andDelegate:self];
    [self presentPopupViewController:self.pageViewController animationType:MJPopupViewAnimationFade];
    //[self presentViewController:self.pageViewController animated:YES completion:nil];
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
