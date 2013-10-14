//
//  SSQuestionNotificationView.m
//  SSlide
//
//  Created by iNghia on 10/15/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import "SSQuestionNotificationView.h"
#import <JSBadgeView/JSBadgeView.h>
#include "CENotifier.h"

@interface SSQuestionNotificationView()

@property (strong, nonatomic) JSBadgeView *badgeView;

@end

@implementation SSQuestionNotificationView

- (void)initView
{
    [[JSBadgeView appearance] setBadgeStrokeWidth:20.f];
    [[JSBadgeView appearance] setBadgeTextFont:[UIFont systemFontOfSize:20.f]];
    self.badgeView = [[JSBadgeView alloc] initWithParentView:self
                                                   alignment:JSBadgeViewAlignmentCenter];
    [self.badgeView setBadgeText:@"0"];
    
}

- (void)addNewQuestion:(NSUInteger)quesNum content:(NSString *)question
{
    [self.badgeView setBadgeText:[NSString stringWithFormat:@"%d", quesNum]];
    NSString *title = [NSString stringWithFormat:@"Question #%d", quesNum];
    
    [CENotifier displayInView:self
                     imageurl:nil
                        title:title
                         text:question
                     duration:5
                     userInfo:nil
                     delegate:nil];
}

@end
