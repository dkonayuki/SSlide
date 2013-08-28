//
//  SSSlideShowInfoView.h
//  SSlide
//
//  Created by techcamp on 2013/08/28.
//  Copyright (c) 2013年 S2. All rights reserved.
//

#import "SSView.h"

@interface SSSlideShowInfoView : SSView

- (id)initWithFrame:(CGRect)frame andTitle:(NSString *)title andTotalPages:(NSInteger)total;
- (void) setPageNumber:(NSInteger)pageNumber;

@end
