//
//  SSSearchOptionView.h
//  SSlide
//
//  Created by iNghia on 9/11/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import "SSView.h"

@protocol SSSearchOptionViewDelegate <SSViewDelegate>

- (void)searchOptionSeletedDel:(NSUInteger)index;

@end

@interface SSSearchOptionView : SSView

@end
