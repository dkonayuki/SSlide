//
//  SSSlidePageCacheManager.h
//  SSlide
//
//  Created by iNghia on 10/18/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSSlideshow.h"
#import "SSSlideShowViewController.h"

@interface SSSlidePageCacheManager : NSObject

@property (weak, nonatomic) id delegate;

- (id)initWithCurrentSlideshow:(SSSlideshow *)currentSlideshow delegate:(id)delegate;
- (SSSlideShowViewController *)viewControllerAtIndex:(NSUInteger)index;

@end
