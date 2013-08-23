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

@interface SSUserViewController () <SSUserViewDelegate, SSSlideListViewDelegate>

@property (strong, nonatomic) SSUserView *myView;
@property (strong, nonatomic) NSMutableArray *slideArray;
@property (assign, nonatomic) NSInteger currentPage;

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
    // init slideArray
    self.slideArray = [[NSMutableArray alloc] init];
    self.currentPage = 1;
    // show loading
    [SVProgressHUD showWithStatus:@"Loading"];
    [self getUserSlideshows];
    
    /*
     [[SSApi sharedInstance] getSlideshowsByUser:@"rashmi"
     success:^(NSArray *result){
     self.pageManager = [[SSSlideShowPageManager alloc] initWithSlideshow:[result objectAtIndex:0]];
     dispatch_apply([result count], dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(size_t index) {
     SSSlideshow *slideshow = [result objectAtIndex:index];
     [[SSApi sharedInstance] addExtendedSlideInfo:slideshow];
     });
     
     }
     failure:^(void) {     // TODO: error handling
     NSLog(@"search ERROR");
     }];
     
     double delayInSeconds = 3.0;
     dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
     dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
     [self.pageManager refresh];
     [self presentViewController:self.pageManager.pageViewController animated:YES completion:nil];
     });
     */
    
    
    /*
     [[SSApi sharedInstance] checkUsernamePassword:@"thefoolishman"
     password:@"fasdf"
     result:^(BOOL result) {
     if(result) {
     NSLog(@"OK");
     } else {
     NSLog(@"FAIL");
     }
     }];
     */


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SSUserViewDelegate
- (void)segmentedControlChangedDel:(NSUInteger)index
{
    
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
    self.currentPage ++;
    [self getUserSlideshows];
}

- (void)didSelectedAtIndex:(int)index
{
}

- (void)closePopup
{
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}

#pragma mark - private
- (void)getUserSlideshows
{
    // TODO: get setting info
    [[SSApi sharedInstance] getSlideshowsByUser:@"rashmi"
                                        success:^(NSArray *result){
                                            self.currentPage++;
                                            [self.slideArray addObjectsFromArray:result];
                                            [self.myView.slideListView.slideTableView reloadData];
                                            [SVProgressHUD dismiss];
                                        }
                                        failure:^(void) {     // TODO: error handling
                                            NSLog(@"search ERROR");
                                        }];
}

@end
