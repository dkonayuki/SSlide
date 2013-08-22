//
//  SSTopView.h
//  SSlide
//
//  Created by iNghia on 8/21/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import "SSView.h"
#import "SSSlideshow.h"

@protocol SSTopViewDelegate <NSObject>

- (NSInteger) numberOfRow;
- (SSSlideshow *) getDataAtIndex:(int)index;
- (void) didSelectedAtIndex:(int)index;
- (void) getMoreSlides;

@end

@interface SSTopView : SSView

@property (strong, nonatomic) UITableView *slideTableView;

@end
