//
//  SSAdManager.m
//  SSlide
//
//  Created by iNghia on 9/10/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import "SSAdManager.h"

@interface SSAdManager() <ADBannerViewDelegate>

@property (assign, nonatomic) BOOL bannerIsVisible;
@property (assign, nonatomic) CGPoint displayCenter;
@property (assign, nonatomic) CGPoint hiddenCenter;

@end

@implementation SSAdManager

- (id)initWithAdFrame:(CGRect)frame
{
    self = [super init];
    if (self) {
        self.bannerIsVisible = NO;
        float cx = frame.origin.x + frame.size.width/2;
        float cy = frame.origin.y + frame.size.height/
        2;
        NSLog(@"Center: %f %f", cx, cy);
        self.displayCenter = CGPointMake(cx, cy);
        self.hiddenCenter = CGPointMake(cx, cy + frame.size.height);
        
        self.iAdView = [[ADBannerView alloc] initWithFrame:frame];
        self.iAdView.delegate = self;
        self.iAdView.center = self.hiddenCenter;
    }
    return self;
}

#pragma mark - iAd delegate
- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    NSLog(@"Ad OK");
    if (!self.bannerIsVisible) {
        [UIView animateWithDuration:1.0
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.iAdView.center = self.displayCenter;
                         }
                         completion:nil];
        self.bannerIsVisible = YES;
    }
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
    return YES;
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    NSLog(@"Did fail to receive ad with error");
    if (self.bannerIsVisible) {
        [UIView animateWithDuration:1.0
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             self.iAdView.center = self.hiddenCenter;
                         }
                         completion:nil];
        self.bannerIsVisible = NO;
    }
}

@end
