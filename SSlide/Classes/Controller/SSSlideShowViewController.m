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
        //[SVProgressHUD showWithStatus:@"Loading"];
        [self.myView.loadingSpinner startAnimating];
        // load image
        NSString *imageUrl = [NSString stringWithFormat:@"%@%d%@", self.currentSlide.slideImageBaseurl, self.pageIndex, self.currentSlide.slideImageBaseurlSuffix];
        NSLog(@"Image url: %@", imageUrl);
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:imageUrl]];
        AFImageRequestOperation *operation =
        [AFImageRequestOperation imageRequestOperationWithRequest:request
                                                          success:^(UIImage *image) {
                                                              self.myView.imageView.image = image;
                                                              //[SVProgressHUD dismiss];
                                                              [self.myView.loadingSpinner stopAnimating];
                                                          }];
        [operation start];
    }
    
    // add swipe gesture to show control view
    UISwipeGestureRecognizer *swipeLeftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeftAction)];
    [swipeLeftRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.myView addGestureRecognizer:swipeLeftRecognizer];
    
    UISwipeGestureRecognizer *swipeRightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRightAction)];
    [swipeRightRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.myView addGestureRecognizer:swipeRightRecognizer];
    
    //add touch gesture to show info
    UITapGestureRecognizer *touchRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.myView addGestureRecognizer:touchRecognizer];
}

- (void)swipeLeftAction
{
    NSLog(@"left swipe");
    [self.delegate showControlView];
}

- (void)tapAction
{
    [self.delegate toogleInfoView];
}

- (void)swipeRightAction
{
    NSLog(@"Right swipe");
    [self.delegate hideControlView];
}

#pragma mark - SSSlideShowView delegate
- (void)dismissView
{
    [self.delegate closePopup];
    //[self dismissViewControllerAnimated:NO completion:nil];
}

@end
