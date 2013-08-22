//
//  SSSlideShowViewController.h
//  SSlide
//
//  Created by iNghia on 8/22/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import "SSViewController.h"
#import "SSSlideshow.h"

@interface SSSlideShowViewController : SSViewController

@property (assign, nonatomic) NSInteger pageIndex;

- (id)initWithCurrentSlideshow:(SSSlideshow *)currentSlide pageIndex:(NSInteger)index;

@end
