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

@end

@implementation SSSlideShowView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)initView
{
    self.backgroundColor = [UIColor whiteColor];
    self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.imageView];
    
    // pinch gesture
    UIPinchGestureRecognizer *pinchGes = [[UIPinchGestureRecognizer alloc] initWithTarget:self
                                                                                   action:@selector(pinchGestureAction:)];
    [self addGestureRecognizer:pinchGes];
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
        [UIView animateWithDuration:0.5f
                         animations:^(void){
                             CGAffineTransform currentTransform = self.transform;
                             CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, 0.3f, 0.3f);
                             [self setTransform:newTransform];
                         }
                         completion:^(BOOL finished) {
                             if (finished) {
                                 [self.delegate dismissView];
                             }
                         }];
    }
}

@end
