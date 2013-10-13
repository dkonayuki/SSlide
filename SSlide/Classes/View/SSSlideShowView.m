//
//  SSSlideShowView.m
//  SSlide
//
//  Created by iNghia on 8/22/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import "SSSlideShowView.h"

@interface SSSlideShowView() <UIGestureRecognizerDelegate>

@property (assign, nonatomic) float lastScale;
@property (assign, nonatomic) BOOL stopPinch;
@property (strong, nonatomic) UITextView *tmpTextView;

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
    
    self.tmpTextView = [[UITextView alloc] init];
    [self addSubview:self.tmpTextView];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
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
    [self.tmpTextView endEditing:YES];
    [self.tmpTextView becomeFirstResponder];
}

#pragma mark Notifications

- (void)keyboardWillShow:(NSNotification *)notification
{
//    /* Move the toolbar to above the keyboard */
//	[UIView beginAnimations:nil context:NULL];
//	[UIView setAnimationDuration:0.3];
//	CGRect frame = self.inputToolbar.frame;
//    frame.origin.y = self.frame.size.width - frame.size.height - kKeyboardHeightLandscape - kStatusBarHeight;
//	self.inputToolbar.frame = frame;
//	[UIView commitAnimations];
//    //keyboardIsVisible = YES;
}

- (void)keyboardWillHide:(NSNotification *)notification
{
//    /* Move the toolbar back to bottom of the screen */
//	[UIView beginAnimations:nil context:NULL];
//	[UIView setAnimationDuration:0.3];
//	CGRect frame = self.inputToolbar.frame;
//    frame.origin.y = self.frame.size.width - frame.size.height;
//	self.inputToolbar.frame = frame;
//	[UIView commitAnimations];
//    //keyboardIsVisible = NO;
}


@end
