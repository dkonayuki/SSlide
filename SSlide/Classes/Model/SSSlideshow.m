//
//  SSSlideshow.m
//  SSlide
//
//  Created by iNghia on 8/22/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import "SSSlideshow.h"

@implementation SSSlideshow
@synthesize ThumbnailURL = mThumbnailUrl;
@synthesize Created = mCreated;

- (void)setThumbnailURL:(NSString *)ThumbnailURL
{
    mThumbnailUrl = [NSString stringWithFormat:@"http:%@", ThumbnailURL];
}

- (void)setCreated:(NSString *)Created
{
    mCreated = Created;
}

- (void)log
{
    NSLog(@"ID: %@", self.ID);
    NSLog(@"Title: %@", self.Title);
    NSLog(@"Username: %@", self.Username);
    NSLog(@"URL: %@", self.URL);
    NSLog(@"ThumbnailURL: %@", self.ThumbnailURL);
    NSLog(@"Created: %@", self.Created);
}

@end
