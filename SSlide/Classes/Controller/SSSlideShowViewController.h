//
//  SSSlideShowViewController.h
//  SSlide
//
//  Created by iNghia on 8/22/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import "SSViewController.h"
#import "SSSlideshow.h"

@protocol SSSlideSHowViewControllerDelegate <NSObject>

- (void)closePopup;

@end

@interface SSSlideShowViewController : SSViewController

@property (assign, nonatomic) NSInteger pageIndex;
@property (weak, nonatomic) id delegate;

- (id)initWithCurrentSlideshow:(SSSlideshow *)currentSlide pageIndex:(NSInteger)index andDelegate:(id)delegate;

@end
