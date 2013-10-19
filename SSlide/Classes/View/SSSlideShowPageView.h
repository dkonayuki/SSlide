//
//  SSSlideShowPageView.h
//  SSlide
//
//  Created by iNghia on 10/19/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import "SSView.h"
#import "SSQuestionNotificationView.h"

@interface SSSlideShowPageView : SSView

- (void)initSubView:(NSString *)title totalPage:(NSUInteger)totalPage;

- (void)offStreamingBtn;
- (void)toogleInfoView;
- (void)updateInforView:(NSUInteger)pageNum;

- (void)showControlView;
- (void)hideControlView;

- (void)showDownloadProgress:(float)percent;
- (void)showDownloadFinished;

- (void)setDrawingViewSize:(CGSize)size;
- (void)drawingNewPoinst:(NSArray *)points;
- (void)drawingDidEnd;
- (void)clearDrawing;
- (UIImage *)getCopyDrawingImage;
- (void)resetDrawingViewWithImage:(UIImage *)image;
- (void)showDrawingView:(BOOL)show;

- (void)showQuestionNotificationView;
- (void)showNewQuestion:(NSUInteger)quesNum content:(NSString *)question;
- (SSQuestionNotificationView *)getQuestionNotificationView;

@end
