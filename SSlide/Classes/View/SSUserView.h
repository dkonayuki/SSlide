//
//  SSUserView.h
//  SSlide
//
//  Created by iNghia on 8/21/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import "SSView.h"
#import "SSSlideListView.h"

@protocol SSUserViewDelegate <NSObject>

- (void)segmentedControlChangedDel:(NSUInteger)index;
- (void)showSettingsView;

@end

@interface SSUserView : SSView

@property (strong, nonatomic) SSSlideListView *slideListView;

@end
