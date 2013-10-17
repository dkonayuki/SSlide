//
//  SSDrawingView.m
//  SSlide
//
//  Created by iNghia on 9/14/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import "SSDrawingView.h"

@interface SSDrawingView() {
    CGPoint mPts[5];
    NSUInteger mCtr;
    CGFloat mWidth;
    CGFloat mHeight;
}

@property (strong, nonatomic) UIBezierPath *path;
@property (strong, nonatomic)  UIImage *incrementalImage;

@end

@implementation SSDrawingView

- (void)initView
{
    [self setMultipleTouchEnabled:NO];
    self.backgroundColor = [UIColor clearColor];
    self.path = [UIBezierPath bezierPath];
    
    mWidth = self.bounds.size.width;
    mHeight = self.bounds.size.height;
}

- (void)resetSize
{
    mWidth = self.bounds.size.width;
    mHeight = self.bounds.size.height;
}

- (void)resetWithImage:(UIImage *)image
{
    if (image) {
        self.incrementalImage = image;
        [self drawBitmap];
        [self setNeedsDisplay];
        [self.path removeAllPoints];
        mCtr = 0;
    } else {
        [self clear];
    }
}

- (UIImage *)getCopyDrawingImage
{
    return [self.incrementalImage copy];
}

- (void)setLineWidth:(CGFloat)lineWidth
{
    [self.path setLineWidth:lineWidth];
}

- (void)clear
{
    [self.path removeAllPoints];
    self.incrementalImage = nil;
    [self setNeedsDisplay];
}

- (void)didEndTouch
{
    [self drawBitmap];
    [self setNeedsDisplay];
    [self.path removeAllPoints];
    mCtr = 0;
}

- (void)drawNewPoints:(NSArray *)points
{
    CGPoint p0 = [[points objectAtIndex:0] CGPointValue];
    CGPoint p1 = [[points objectAtIndex:1] CGPointValue];
    CGPoint p2 = [[points objectAtIndex:2] CGPointValue];
    CGPoint p3 = [[points objectAtIndex:3] CGPointValue];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.path moveToPoint:CGPointMake(p0.x * mWidth, p0.y * mHeight)];
        [self.path addCurveToPoint:CGPointMake(p3.x * mWidth, p3.y * mHeight)
                     controlPoint1:CGPointMake(p1.x * mWidth, p1.y * mHeight)
                     controlPoint2:CGPointMake(p2.x * mWidth, p2.y * mHeight)];
        [self setNeedsDisplay];
    });
}

#pragma mark - private
- (void)drawRect:(CGRect)rect
{
    [self.lineColor setStroke];
    [self.incrementalImage drawInRect:rect];
    [self.path stroke];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    mCtr = 0;
    UITouch *touch = [touches anyObject];
    mPts[0] = [touch locationInView:self];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    mCtr++;
    mPts[mCtr] = p;
    if (mCtr == 4)
    {
        mPts[3] = CGPointMake((mPts[2].x + mPts[4].x)/2.0, (mPts[2].y + mPts[4].y)/2.0);
        [self.path moveToPoint:mPts[0]];
        [self.path addCurveToPoint:mPts[3] controlPoint1:mPts[1] controlPoint2:mPts[2]];
        [self setNeedsDisplay];
        
        NSArray *points = [NSArray arrayWithObjects:
                           [NSValue valueWithCGPoint:CGPointMake(mPts[0].x/mWidth, mPts[0].y/mHeight)],
                           [NSValue valueWithCGPoint:CGPointMake(mPts[1].x/mWidth, mPts[1].y/mHeight)],
                           [NSValue valueWithCGPoint:CGPointMake(mPts[2].x/mWidth, mPts[2].y/mHeight)],
                           [NSValue valueWithCGPoint:CGPointMake(mPts[3].x/mWidth, mPts[3].y/mHeight)], nil];
        [self.delegate didAddPointsDel:points];
        
        mPts[0] = mPts[3];
        mPts[1] = mPts[4];
        mCtr = 1;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self drawBitmap];
    [self setNeedsDisplay];
    [self.path removeAllPoints];
    mCtr = 0;
    [self.delegate didEndTouchDel];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self touchesEnded:touches withEvent:event];
}

- (void)drawBitmap
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
    [self.lineColor setStroke];
    [self.incrementalImage drawAtPoint:CGPointZero];
    [self.path stroke];
    self.incrementalImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
}

@end
