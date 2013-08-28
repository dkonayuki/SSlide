//
//  SSTextFieldView.h
//  SSlide
//
//  Created by iNghia on 8/28/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import "SSView.h"

@protocol SSTextFieldViewDelegate <NSObject>

- (void)textFieldDidBeginEditingDel;

@end

@interface SSTextFieldView : SSView

- (id)initWithFrame:(CGRect)frame delegate:(id)delegate imageName:(NSString *)image color:(UIColor *)color isPassword:(BOOL)isPassword placeholder:(NSString *)placeholder;

- (NSString *)getText;

@end
