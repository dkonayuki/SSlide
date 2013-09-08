//
//  SSSearchView.h
//  SSlide
//
//  Created by iNghia on 8/21/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import "SSView.h"
#import "SSSlideshow.h"
#import "SSSlideListView.h"

/* */
@protocol SSSearchViewDelegate <SSViewDelegate>

- (void)searchText:(NSString *)text firstTime:(BOOL)fTime completion:(void (^)(void))completed;

@end

/* */
@interface SSSearchView : SSView

@property (strong, nonatomic) UITextField *searchTextField;
@property (strong, nonatomic) SSSlideListView *slideListView;

- (void) initSlideListView;
- (void) moveToTop;

@end
