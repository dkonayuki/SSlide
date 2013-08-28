//
//  SSAddTagView.h
//  SSlide
//
//  Created by iNghia on 8/28/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import "SSView.h"

@interface SSAddTagView : SSView

@property (assign, nonatomic) float fontSize;

- (id)initWithFrame:(CGRect)frame andDelegate:(id)delegate fontSize:(float)fontSize;

- (void)refresh;

@end

@protocol SSAddTagViewDelegate <NSObject>

- (void)redrawDel;
- (void)addTagDel:(NSString *)tagText;

@end