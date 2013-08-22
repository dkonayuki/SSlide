//
//  SSSlideshow.m
//  SSlide
//
//  Created by iNghia on 8/22/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import "SSSlideshow.h"

@implementation SSSlideshow
@synthesize thumbnailUrl = mThumbnailUrl;
@synthesize created = mCreated;
@synthesize slideImageBaseurl = mSlideImageBaseUrl;

- (void)setThumbnailUrl:(NSString *)thumbnailUrl
{
    mThumbnailUrl = [NSString stringWithFormat:@"http:%@", thumbnailUrl];
}

- (void)setCreated:(NSString *)created
{
    mCreated = created;
}

- (void)setSlideImageBaseurl:(NSString *)slideImageBaseurl
{
    mSlideImageBaseUrl = [NSString stringWithFormat:@"http:%@", slideImageBaseurl];
}

- (void)log
{
    NSLog(@"ID: %@", self.slideId);
    NSLog(@"Title: %@", self.title);
    NSLog(@"Username: %@", self.username);
    NSLog(@"URL: %@", self.url);
    NSLog(@"ThumbnailURL: %@", self.thumbnailUrl);
    NSLog(@"Created: %@", self.created);
    NSLog(@"Total slides: %d", self.totalSlides);
    NSLog(@"Base url: %@", self.slideImageBaseurl);
    NSLog(@"Base url suffix: %@", self.slideImageBaseurlSuffix);
    NSLog(@"First page image url: %@", self.firstPageImageUrl);
}

- (BOOL)extendedInfoIsNil
{
    if (self.slideImageBaseurl && self.slideImageBaseurlSuffix) {
        return NO;
    }
    return YES;
}

@end
