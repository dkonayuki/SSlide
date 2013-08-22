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
#import "SSSlideshow.h"
#import "SSSlideShowPageManager.h"

@interface SSTopViewController () <SSTopViewDelegate>

@property (strong, nonatomic) SSTopView *myView;
@property (strong, nonatomic) NSMutableArray *slideArray;
@property (strong, nonatomic) SSSlideShowPageManager *pageManager;

@end

@implementation SSTopViewController
{
    NSInteger currentPage;
}

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
    currentPage = 1;
    self.myView = [[SSTopView alloc] initWithFrame:self.view.bounds andDelegate:self];
    self.view = self.myView;
    
    self.slideArray = [[NSMutableArray alloc] init];
    /*
    NSString *params = @"q=GCD&page=1&items_per_page=10";
    [[SSApi sharedInstance] searchSlideshows:params
                                     success:^(NSArray *result){
                                         NSLog(@"%d", [result count]);
                                         for (SSSlideshow *cur in result) {
                                             [cur log];
                                         }
                                     }
                                     failure:^(void) {     // TODO: error handling
                                         NSLog(@"search ERROR");
                                     }];
     */
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
    
    [[SSApi sharedInstance] getMostViewedSlideshows:@"Ruby"
                                               page:currentPage
                                       itemsPerPage:10
                                            success:^(NSArray *result){
                                                [self.slideArray addObjectsFromArray:result];
                                               
                                                /*NSLog(@"%d", [self.slideArray count]);
                                                for (SSSlideshow *cur in self.slideArray) {
                                                    [cur log];
                                                }*/
                                                [self.myView.slideTableView reloadData];
                                            }
                                            failure:^(void) {     // TODO: error handling
                                                NSLog(@"search ERROR");
                                            }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SSTopView delegate
- (NSInteger)numberOfRow
{
    return self.slideArray.count;
}

- (SSSlideshow *)getDataAtIndex:(int)index
{
    return [self.slideArray objectAtIndex:index];
}

- (void)getMoreSlides
{
    currentPage++;
    [[SSApi sharedInstance] getMostViewedSlideshows:@"Ruby"
                                               page:currentPage
                                       itemsPerPage:10
                                            success:^(NSArray *result){
                                                [self.slideArray addObjectsFromArray:result];
                                                [self.myView.slideTableView reloadData];
                                            }
                                            failure:^(void) {     // TODO: error handling
                                                NSLog(@"search ERROR");
                                            }];
}

@end
