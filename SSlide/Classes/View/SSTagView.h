//
//  SSTagView.h
//  SSlide
//
//  Created by iNghia on 8/28/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import "SSView.h"

@interface SSTagView : SSView

@property (strong, nonatomic) NSString *text;
@property (assign, nonatomic) float fontSize;

- (id)initWithFrame:(CGRect)frame andDelegate:(id)delegate text:(NSString *)text fontSize:(float)fontSize;

- (void)refresh;

@end

@protocol SSTagViewDelegate <SSViewDelegate>

- (void)redrawDel;
- (void)removeTagDel:(SSTagView *)tagView;

@end