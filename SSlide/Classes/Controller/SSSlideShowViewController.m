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
        UIImage *image = [UIImage imageWithContentsOfFile:[self.currentSlide localUrlOfImageAtPage:self.pageIndex]];
        self.myView.imageView.image = image;
        [self.delegate setImageSize:image.size];
    } else {
        [self.myView.loadingSpinner startAnimating];
        // load image
        NSString *imageUrl = [NSString stringWithFormat:@"%@%d%@", self.currentSlide.slideImageBaseurl, self.pageIndex, self.currentSlide.slideImageBaseurlSuffix];
        NSLog(@"Image url: %@", imageUrl);
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:imageUrl]];
        AFImageRequestOperation *operation =
        [AFImageRequestOperation imageRequestOperationWithRequest:request
                                                          success:^(UIImage *image) {
                                                              self.myView.imageView.image = image;
                                                              [self.delegate setImageSize:image.size];
                                                              [self.myView.loadingSpinner stopAnimating];
                                                          }];
        [operation start];
    }
}

#pragma mark - SSSlideShowView delegate
- (void)dismissView
{
    [self.delegate closePopup];
}

- (void)createQuestion:(NSString *)question
{
    [self.delegate sendQuestion:question];
}

- (void)swipeLeftAction
{
    [self.delegate showControlView];
}

- (void)tapAction
{
    [self.delegate toogleInfoView];
}

- (void)swipeRightAction
{
    [self.delegate hideControlView];
}

@end
