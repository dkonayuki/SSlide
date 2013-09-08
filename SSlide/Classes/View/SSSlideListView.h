//
//  SSSlideListView.h
//  SSlide
//
//  Created by techcamp on 2013/08/23.
//  Copyright (c) 2013年 S2. All rights reserved.
//

#import "SSView.h"
#import "SSSlideshow.h"

@protocol SSSlideListViewDelegate <NSObject>

- (NSInteger) numberOfRows;
- (SSSlideshow *) getDataAtIndex:(int)index;
- (void) didSelectedAtIndex:(int)index;

@optional
- (void) getMoreSlides:(void (^)(void))completed;

@end

@interface SSSlideListView : SSView

@property (strong, nonatomic) UITableView *slideTableView;
@property (assign, nonatomic) BOOL infiniteLoad;

- (void)reloadRowsWithAnimation;
- (void)addRowsWithAnimation:(NSUInteger)from andSum:(NSUInteger)sum;

@end
