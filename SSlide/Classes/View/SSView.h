//
//  SSView.h
//  SSlide
//
//  Created by iNghia on 8/21/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FUIButton.h>
#import <FlatUIKit/UIColor+FlatUI.h>
#import <FlatUIKit/UIFont+FlatUI.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import <FLKAutoLayout/FLKAutoLayoutPredicateList.h>
#import "SSDB5.h"

@protocol SSViewDelegate <NSObject>

@end

@interface SSView : UIView

@property (weak, nonatomic) id delegate;

- (id)initWithFrame:(CGRect)frame andDelegate:(id) delegate;
- (void)initView;
- (void)updateContent;

@end
