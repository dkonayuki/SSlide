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

- (id)initWithCurrentSlideshow:(SSSlideshow *)currentSlide pageIndex:(NSInteger)index andDelegate:(id)delegate
{
    self = [super init];
    if (self) {
        self.delegate = delegate;
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
    
    if ([self.currentSlide checkIsDownloaded]) {
        self.myView.imageView.image = [UIImage imageWithContentsOfFile:[self.currentSlide localUrlOfImageAtPage:self.pageIndex]];
    } else {
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SSSlideShowView delegate
- (void)dismissView
{
    [self.delegate closePopup];
    //[self dismissViewControllerAnimated:NO completion:nil];
}

- (void)downloadCurrentSlide
{
    if (![self.currentSlide checkIsDownloaded]) {
        [self.currentSlide download:^(float percent) {
            NSLog(@"download: %f", percent);
        } completion:^(BOOL result){
            [SVProgressHUD showSuccessWithStatus:@"OK"];
        }];
    } else {
        [SVProgressHUD showErrorWithStatus:@"Already exists!"];
    }
}

@end
