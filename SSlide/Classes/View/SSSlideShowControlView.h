//
//  SSSlideShowControlView.h
//  SSlide
//
//  Created by iNghia on 8/24/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import "SSView.h"

@protocol SSSlideShowControlViewDelegate <NSObject>

- (void)downloadCurrentSlideDel;
- (void)startStreamingCurrentSlideDel;

@end

@interface SSSlideShowControlView : SSView

@end
