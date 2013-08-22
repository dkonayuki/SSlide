//
//  SSTopView.h
//  SSlide
//
//  Created by iNghia on 8/21/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import "SSView.h"

@protocol SSTopViewDelegate <NSObject>

- (NSInteger)numberOfRow;
- (NSDictionary *) getDataAtIndex:(int)index;

@end


@interface SSTopView : SSView

@end
