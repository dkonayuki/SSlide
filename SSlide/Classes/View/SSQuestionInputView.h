//
//  SSQuestionInputView.h
//  SSlide
//
//  Created by iNghia on 10/14/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import "SSView.h"

@protocol SSQuestionInputViewDelegate <SSViewDelegate>

- (void)sendQuestion:(NSString *)question;
- (void)cancelQuestion;

@end

@interface SSQuestionInputView : SSView

- (void)show;
- (void)hide;

@end
