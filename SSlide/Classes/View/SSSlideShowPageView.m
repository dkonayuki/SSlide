//
//  SSSlideShowPageView.m
//  SSlide
//
//  Created by iNghia on 10/19/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import "SSSlideShowPageView.h"
#import "SSSlideShowControlView.h"
#import "SSSlideShowInfoView.h"
#import "SSStreamingManager.h"
#import "SSDrawingView.h"

@interface SSSlideShowPageView()

@property (strong, nonatomic) SSSlideShowControlView *controlView;
@property (strong, nonatomic) SSSlideShowInfoView *infoView;
@property (strong, nonatomic) SSDrawingView *drawingView;
@property (strong, nonatomic) SSQuestionNotificationView *questionNotificationView;
@property (strong, nonatomic) FUIAlertView *alertView;

@end

@implementation SSSlideShowPageView

- (void)initSubView:(NSString *)title totalPage:(NSUInteger)totalPage
{
    // drawing view
    self.drawingView = [[SSDrawingView alloc] initWithFrame:self.bounds
                                                andDelegate:self.delegate];
    self.drawingView.lineColor = [UIColor orangeColor];
    float lineWidth = IS_IPAD ? [[SSDB5 theme] floatForKey:@"drawing_pen_width_ipad"] : [[SSDB5 theme] floatForKey:@"drawing_pen_width_iphone"];
    self.drawingView.lineWidth = lineWidth;
    [self addSubview:self.drawingView];
    self.drawingView.hidden = YES;
    
    // control view
    float width = IS_IPAD ? [[SSDB5 theme] floatForKey:@"slide_control_view_height_ipad"] : [[SSDB5 theme] floatForKey:@"slide_control_view_height_iphone"];
    float height = IS_IPAD ? 580.f : 270.f;
    CGRect rect = CGRectMake(self.bounds.size.width - width, 0, height, width);
    self.controlView = [[SSSlideShowControlView alloc] initWithFrame:rect
                                                         andDelegate:self.delegate];
    self.controlView.transform = CGAffineTransformMakeRotation(M_PI_2);
    self.controlView.center = CGPointMake(self.bounds.size.width + width/2, self.bounds.size.height/2);
    [self addSubview:self.controlView];
    
    //info view
    self.infoView = [[SSSlideShowInfoView alloc] initWithFrame:CGRectMake(0, 0, 100.f, width)
                                                      andTitle:title
                                                 andTotalPages:totalPage];
    [self addSubview:self.infoView];
    self.infoView.transform = CGAffineTransformMakeRotation(M_PI_2);
    self.infoView.center = CGPointMake(width/2, self.center.y);
    self.infoView.alpha = 0.f;
    
    // question view
    float qw = 50.f;
    float left_margin = 10.f;
    float top_margin = 30.f;
    self.questionNotificationView = [[SSQuestionNotificationView alloc] initWithFrame:CGRectMake(0, 0, qw, qw)
                                                                          andDelegate:self.delegate];
    [self.questionNotificationView setNotificationViewHeight:self.bounds.size.width];
    self.questionNotificationView.backgroundColor = [UIColor clearColor];
    self.questionNotificationView.transform = CGAffineTransformMakeRotation(M_PI_2);
    self.questionNotificationView.center = CGPointMake(self.bounds.size.width - qw/2 - top_margin,
                                                       self.bounds.size.height - qw/2 - left_margin);
    [self addSubview:self.questionNotificationView];
    self.questionNotificationView.hidden = YES;
}

#pragma mark - INFO VIEW
- (void)toogleInfoView
{
    if (self.infoView.alpha == 0) {
        [UIView animateWithDuration:0.5f animations:^(void) {
            self.infoView.alpha = 1.0;
        }];
    }
    else {
        [UIView animateWithDuration:0.5f animations:^(void) {
            self.infoView.alpha = 0;
        }];
    }
}

- (void)updateInforView:(NSUInteger)pageNum
{
    [self.infoView setPageNumber:pageNum];
}

#pragma mark - CONTROL VIEW
- (void)offStreamingBtn
{
    [self.controlView offStreamingBtn];
}

- (void)showControlView
{
    [UIView animateWithDuration:0.5f
                     animations:^(void) {
                         float cW = IS_IPAD ? [[SSDB5 theme] floatForKey:@"slide_control_view_height_ipad"] : [[SSDB5 theme] floatForKey:@"slide_control_view_height_iphone"];
                         if(IS_IPHONE && SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
                             cW += 20.f;
                         }
                         self.controlView.center = CGPointMake(self.bounds.size.width - cW/2, self.center.y);
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}

- (void)hideControlView
{
    NSLog(@"hide control view");
    [UIView animateWithDuration:0.35f
                     animations:^(void) {
                         float cW = IS_IPAD ? [[SSDB5 theme] floatForKey:@"slide_control_view_height_ipad"] : [[SSDB5 theme] floatForKey:@"slide_control_view_height_iphone"];
                         self.controlView.center = CGPointMake(self.bounds.size.width + cW/2, self.center.y);
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}

- (void)showDownloadProgress:(float)percent
{
    [self.controlView setDownloadProgress:percent];
}

- (void)showDownloadFinished
{
    [self.controlView setFinishDownload];
}


#pragma mark - DRAWING VIEW
- (void)setDrawingViewSize:(CGSize)size
{
    float cw = self.drawingView.bounds.size.width;
    float ch = self.drawingView.bounds.size.height;
    float cr = cw/ch;
    float iw = size.height;
    float ih = size.width;
    float ir = iw/ih;
    
    if (cr > ir) {
        float nw = ch * ir;
        float dw = (cw - nw)/2;
        self.drawingView.frame = CGRectMake(dw, 0, nw, ch);
        [self.drawingView resetSize];
    } else if (cr < ir) {
        float nh = cw / ir;
        float dh = (ch - nh)/2;
        self.drawingView.frame = CGRectMake(0, dh, cw, nh);
        [self.drawingView resetSize];
    }
}

- (void)drawingNewPoinst:(NSArray *)points
{
    [self.drawingView drawNewPoints:points];
}

- (void)drawingDidEnd
{
    [self.drawingView didEndTouch];
}

- (void)clearDrawing
{
    [self.drawingView clear];
}

- (UIImage *)getCopyDrawingImage
{
    return [self.drawingView getCopyDrawingImage];
}

- (void)resetDrawingViewWithImage:(UIImage *)image
{
    [self.drawingView resetWithImage:image];
}

- (void)showDrawingView:(BOOL)show
{
    self.drawingView.hidden = !show;
}

#pragma mark - QUESTION NOTIFICATION VIEW
- (void)showQuestionNotificationView
{
    self.questionNotificationView.hidden = NO;
}

- (void)showNewQuestion:(NSUInteger)quesNum content:(NSString *)question
{
    [self.questionNotificationView addNewQuestion:quesNum content:question];
}

- (SSQuestionNotificationView *)getQuestionNotificationView
{
    return self.questionNotificationView;
}

@end
