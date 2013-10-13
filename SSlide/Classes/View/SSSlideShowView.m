//
//  SSSlideShowView.m
//  SSlide
//
//  Created by iNghia on 8/22/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import "SSSlideShowView.h"
#import <QuartzCore/QuartzCore.h>

@interface SSSlideShowView() <UIGestureRecognizerDelegate>

@property (assign, nonatomic) float lastScale;
@property (assign, nonatomic) BOOL stopPinch;
@property (strong, nonatomic) UIView *questionInputView;
@property (strong, nonatomic) UITextView *questionInputTextView;
@property (assign, nonatomic) BOOL inputViewIsShowing;

@end

@implementation SSSlideShowView

- (void)initView
{
    self.backgroundColor = [UIColor whiteColor];
    CGRect imageRect = CGRectMake(0, 0, self.bounds.size.height, self.bounds.size.width);
    self.imageView = [[UIImageView alloc] initWithFrame:imageRect];
    self.imageView.transform = CGAffineTransformMakeRotation(M_PI_2);
    self.imageView.center = CGPointMake(self.center.x, self.center.y);
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.imageView];
    
    // pinch gesture
    UIPinchGestureRecognizer *pinchGes = [[UIPinchGestureRecognizer alloc] initWithTarget:self
                                                                                   action:@selector(pinchGestureAction:)];
    [self addGestureRecognizer:pinchGes];
    
    // loading spinner
    self.loadingSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    float width = 50.f;
    //self.loadingSpinner.backgroundColor = [UIColor greenSeaColor];
    self.loadingSpinner.frame = CGRectMake(0, self.bounds.size.height - width, width, width);
    [self addSubview:self.loadingSpinner];
    
    // long press gesture
    UILongPressGestureRecognizer *longPressGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                               action:@selector(longPressGestureAction:)];
    [self addGestureRecognizer:longPressGes];
    self.inputViewIsShowing = NO;
    
    float w = IS_IPAD ? 500 : 300;
    float h = IS_IPAD ? 200 : 100;
    float cx = self.bounds.size.width - h/2 - 30.f;
    float cy = self.center.y;
    float font_size = IS_IPAD ? 30.f : 20.f;
    float btnw = h/2;
    self.questionInputView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, w + btnw, h)];
    self.questionInputView.backgroundColor = [UIColor clearColor];
    
    self.questionInputTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
    self.questionInputTextView.font = [UIFont systemFontOfSize:font_size];
    self.questionInputTextView.layer.cornerRadius = 5.f;
    self.questionInputTextView.layer.borderWidth = 2.f;
    self.questionInputTextView.layer.borderColor = [[SSDB5 theme] colorForKey:@"question_input_border_color"].CGColor;
    [self.questionInputView addSubview:self.questionInputTextView];
    
    self.questionInputView.transform = CGAffineTransformMakeRotation(M_PI_2);
    self.questionInputView.center = CGPointMake(cx, cy);
    [self addSubview:self.questionInputView];
    
    self.questionInputView.hidden = YES;
    
    UIButton *sendButton = [[UIButton alloc] initWithFrame:CGRectMake(w, 0, btnw, btnw)];
    [sendButton setTitle:@"Send" forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(sendQuestionButtonPressed) forControlEvents:UIControlEventTouchDown];
    [self.questionInputView addSubview:sendButton];
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(w, btnw, btnw, btnw)];
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelQuestionButtonPressed) forControlEvents:UIControlEventTouchDown];
    [self.questionInputView addSubview:cancelButton];
}

- (void)pinchGestureAction:(UIPinchGestureRecognizer *)sender
{
    switch ([sender state]) {
        case UIGestureRecognizerStateBegan:
            self.lastScale = 1.f;
            self.stopPinch = NO;
            break;
        case UIGestureRecognizerStateEnded: {
            if (self.stopPinch) {
                break;
            }
        }
        case UIGestureRecognizerStateCancelled: {
            [UIView animateWithDuration:0.5f
                             animations:^(void){
                                 CGAffineTransform currentTransform = self.transform;
                                 currentTransform.a = 1.f;
                                 currentTransform.d = 1.f;
                                 [self setTransform:currentTransform];
                             }
                             completion:^(BOOL finished) {
                            }];
            
        }
            return;
        default:
            break;
    }
    
    if (self.stopPinch) {
        return;
    }
    
    CGFloat scale = 1.0 - (self.lastScale - [sender scale]);
    
    CGAffineTransform currentTransform = self.transform;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
    [self setTransform:newTransform];
    self.lastScale = [sender scale];
    
    if (self.lastScale <= 0.5f) {
        self.stopPinch = YES;
        [UIView animateWithDuration:0.3f
                         animations:^(void){
                             CGAffineTransform currentTransform = self.transform;
                             CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, 0.2f, 0.2f);
                             newTransform = CGAffineTransformRotate(newTransform, -M_PI_2);
                             [self setTransform:newTransform];
                         }
                         completion:^(BOOL finished) {
                             if (finished) {
                                 [self.delegate dismissView];
                             }
                         }];
    }
}

- (void)longPressGestureAction:(UILongPressGestureRecognizer *)sender
{
    if (self.inputViewIsShowing) {
        return;
    }
    self.inputViewIsShowing = YES;
    
    self.questionInputView.hidden = NO;
    [self.questionInputTextView becomeFirstResponder];
}

- (void)sendQuestionButtonPressed
{
    NSLog(@"Send Question");
    [self.delegate createQuestion:self.questionInputTextView.text];
    [self cancelQuestionButtonPressed];
}

- (void)cancelQuestionButtonPressed
{
    self.questionInputView.hidden = YES;
    self.inputViewIsShowing = NO;
    [self.questionInputTextView resignFirstResponder];
    NSLog(@"cancel Question");
}

@end
