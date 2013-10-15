//
//  SSQuestionNotificationView.h
//  SSlide
//
//  Created by iNghia on 10/15/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import "SSView.h"

@protocol SSQuestionNotificationViewDelegate <SSViewDelegate>

- (void)showQuestionList;

@end

@interface SSQuestionNotificationView : SSView

- (void)setNotificationViewHeight:(float)height;
- (void)addNewQuestion:(NSUInteger)quesNum content:(NSString *)question;

@end
