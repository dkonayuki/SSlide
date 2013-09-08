//
//  SSTagsListView.h
//  SSlide
//
//  Created by iNghia on 8/28/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import "SSView.h"
#import "SSTagView.h"

@protocol SSTagsListViewDelegate <SSViewDelegate>

- (void)didAddTag:(NSString *)tag;
- (void)didRemoveTag:(NSString *)tag;

@end

@interface SSTagsListView : SSView

- (id)initWithFrame:(CGRect)frame andDelegate:(id)delegate andTagStrings:(NSMutableArray *)tagStrings;

@end
