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

@interface SSTopViewController ()

@property (strong, nonatomic) SSTopView *myView;

@end

@implementation SSTopViewController

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
    self.myView = [[SSTopView alloc] initWithFrame:self.view.bounds andDelegate:self];
    self.view = self.myView;
    
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
