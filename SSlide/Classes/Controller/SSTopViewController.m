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

@interface SSTopViewController () <SSTopViewDelegate>

@property (strong, nonatomic) SSTopView *myView;
@property (strong, nonatomic) NSMutableArray *slideArray;

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
    [[SSApi sharedInstance] getSlideshowsByUser:@"thefoolishman"
                                        success:^(NSArray *result){
                                            NSLog(@"%d", [result count]);
                                            for (SSSlideshow *cur in result) {
                                                [cur log];
                                            }
                                            
                                            SSSlideshow *firstSlideshow = [result objectAtIndex:0];
                                            [[SSApi sharedInstance] getExtendedSlideInfo:firstSlideshow.URL];
                                        }
                                        failure:^(void) {     // TODO: error handling
                                            NSLog(@"search ERROR");
                                        }];
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
