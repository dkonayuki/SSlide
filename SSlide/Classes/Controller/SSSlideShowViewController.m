//
//  SSSlideShowViewController.m
//  SSlide
//
//  Created by iNghia on 8/22/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import "SSSlideShowViewController.h"
#import "SSSlideShowView.h"
#import <AFNetworking/AFImageRequestOperation.h>

@interface SSSlideShowViewController () <SSSlideShowViewDelegate>

@property (strong, nonatomic) SSSlideShowView *myView;
@property (strong, nonatomic) SSSlideshow *currentSlide;
@property (assign, nonatomic) NSInteger pageIndex;

@end

@implementation SSSlideShowViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCurrentSlideshow:(SSSlideshow *)currentSlide pageIndex:(NSInteger)index
{
    self = [super init];
    if (self) {
        self.currentSlide = currentSlide;
        self.pageIndex = index;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.myView = [[SSSlideShowView alloc] initWithFrame:self.view.bounds andDelegate:self];
    self.view = self.myView;
    [SVProgressHUD showWithStatus:@"loading"];
    // load image
    NSString *imageUrl = [NSString stringWithFormat:@"%@%d%@", self.currentSlide.slideImageBaseurl, self.pageIndex, self.currentSlide.slideImageBaseurlSuffix];
    NSLog(@"Image url: %@", imageUrl);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:imageUrl]];
    AFImageRequestOperation *operation =
    [AFImageRequestOperation imageRequestOperationWithRequest:request
                                                      success:^(UIImage *image) {
                                                          self.myView.imageView.image = image;
                                                          [SVProgressHUD dismiss];
                                                      }];
    [operation start];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SSSlideShowView delegate
- (void)dismissView
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

@end
