//
//  SSQuestionNotificationView.m
//  SSlide
//
//  Created by iNghia on 10/15/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import "SSQuestionNotificationView.h"
#include "CENotifier.h"

@interface SSQuestionNotificationView()

@property (strong, nonatomic) UIButton *badgeButton;
@property (strong, nonatomic) UIView *quesNotificationView;

@end

@implementation SSQuestionNotificationView

- (void)initView
{
    float btnW = self.bounds.size.width;
    self.badgeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, btnW, btnW)];
    self.badgeButton.layer.cornerRadius = btnW/2;
    self.badgeButton.backgroundColor = [UIColor redColor];
    [self.badgeButton setTitle:@"0" forState:UIControlStateNormal];
    [self.badgeButton addTarget:self action:@selector(badgeButtonPressed) forControlEvents:UIControlEventTouchDown];
    [self addSubview:self.badgeButton];
    
    self.quesNotificationView = [[UIView alloc] initWithFrame:CGRectMake(btnW, btnW, 0, 500.f)];
    [self addSubview:self.quesNotificationView];
}

- (void)setNotificationViewHeight:(float)height
{
    self.quesNotificationView.frame = CGRectMake(self.bounds.size.width, self.bounds.size.width, 0, height);
}

- (void)addNewQuestion:(NSUInteger)quesNum content:(NSString *)question
{
    [self.badgeButton setTitle:[NSString stringWithFormat:@"%d", quesNum] forState:UIControlStateNormal];
    if ([question length] <= 0) {
        return;
    }
    
    NSString *title = [NSString stringWithFormat:@"Question #%d", quesNum];
    [CENotifier displayInView:self.quesNotificationView
                     imageurl:nil
                        title:title
                         text:question
                     duration:5
                     userInfo:nil
                     delegate:nil];
}

- (void)badgeButtonPressed
{
    [self.delegate showQuestionList];
}

@end
