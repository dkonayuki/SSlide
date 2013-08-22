//
//  SSSlideShowPageManager.h
//  SSlide
//
//  Created by iNghia on 8/22/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MNPageViewController/MNPageViewController.h>
#import "SSSlideShowViewController.h"
#import "SSSlideshow.h"

@interface SSSlideShowPageManager : NSObject

@property (strong, nonatomic) MNPageViewController *pageViewController;
- (id)initWithSlideshow:(SSSlideshow *)slideshow;

- (void)refresh;

@end
