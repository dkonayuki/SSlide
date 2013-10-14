//
//  SSSlideShowView.m
//  SSlide
//
//  Created by iNghia on 8/22/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import "SSSlideShowView.h"
#import <QuartzCore/QuartzCore.h>
#import "SSQuestionInputView.h"

@interface SSSlideShowView() <UIGestureRecognizerDelegate, SSQuestionInputViewDelegate>

@property (assign, nonatomic) float lastScale;
@property (assign, nonatomic) BOOL stopPinch;
@property (strong, nonatomic) SSQuestionInputView *questionInputView;
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
    
    float w = IS_IPAD ? 600 : 350;
    float h = IS_IPAD ? 200 : 80;
    float cx = self.bounds.size.width/2 + h/2 + 10.f;
    float cy = self.center.y;
    
    self.questionInputView = [[SSQuestionInputView alloc] initWithFrame:CGRectMake(0, 0, w , h) andDelegate:self];
    self.questionInputView.backgroundColor = [UIColor clearColor];
    self.questionInputView.transform = CGAffineTransformMakeRotation(M_PI_2);
    self.questionInputView.center = CGPointMake(cx, cy);
    [self addSubview:self.questionInputView];
    
    // add swipe gesture to show control view
    UISwipeGestureRecognizer *swipeLeftRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeftAction)];
    [swipeLeftRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self addGestureRecognizer:swipeLeftRecognizer];
    
    UISwipeGestureRecognizer *swipeRightRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRightAction)];
    [swipeRightRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    [self addGestureRecognizer:swipeRightRecognizer];
    
    //add touch gesture to show info
    UITapGestureRecognizer *touchRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self addGestureRecognizer:touchRecognizer];
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
    
    [self.questionInputView show];
}

- (void)swipeLeftAction
{
    [self.delegate swipeLeftAction];
}

- (void)tapAction
{
    [self.delegate tapAction];
    if (self.inputViewIsShowing) {
        [self.questionInputView hide];
        self.inputViewIsShowing = NO;
    }
}

- (void)swipeRightAction
{
    [self.delegate swipeRightAction];
}

#pragma mark - SSQuestionInputViewDelegate
- (void)sendQuestion:(NSString *)question
{
    [self.delegate createQuestion:question];
    self.inputViewIsShowing = NO;
}

- (void)cancelQuestion
{
    self.inputViewIsShowing = NO;
}

@end
