//
//  SSDrawingView.h
//  SSlide
//
//  Created by iNghia on 9/14/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import "SSView.h"

@protocol SSDrawingViewDelegate <SSViewDelegate>

- (void)didAddPointsDel:(NSArray *)points;
- (void)didEndTouchDel;

@end

@interface SSDrawingView : SSView

@property (strong, nonatomic) UIColor *lineColor;
@property (assign, nonatomic) CGFloat lineWidth;

- (void)drawNewPoints:(NSArray *)points;
- (void)didEndTouch;

- (void)clear;


@end
