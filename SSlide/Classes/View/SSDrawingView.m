//
//  SSDrawingView.m
//  SSlide
//
//  Created by iNghia on 9/14/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import "SSDrawingView.h"

@interface SSDrawingView() {
    CGPoint _pts[5];
    NSUInteger _ctr;
    CGFloat _vWidth;
    CGFloat _vHeight;
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
    
    _vWidth = self.bounds.size.width;
    _vHeight = self.bounds.size.height;
}

- (void)setLineWidth:(CGFloat)lineWidth
{
    [self.path setLineWidth:lineWidth];
}

- (void)drawRect:(CGRect)rect
{
    [self.lineColor setStroke];
    [self.incrementalImage drawInRect:rect];
    [self.path stroke];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    _ctr = 0;
    UITouch *touch = [touches anyObject];
    _pts[0] = [touch locationInView:self];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint p = [touch locationInView:self];
    _ctr++;
    _pts[_ctr] = p;
    if (_ctr == 4)
    {
        _pts[3] = CGPointMake((_pts[2].x + _pts[4].x)/2.0, (_pts[2].y + _pts[4].y)/2.0);
        [self.path moveToPoint:_pts[0]];
        [self.path addCurveToPoint:_pts[3] controlPoint1:_pts[1] controlPoint2:_pts[2]];
        [self setNeedsDisplay];
        
        NSArray *points = [NSArray arrayWithObjects:
                           [NSValue valueWithCGPoint:CGPointMake(_pts[0].x/_vWidth, _pts[0].y/_vHeight)],
                           [NSValue valueWithCGPoint:CGPointMake(_pts[1].x/_vWidth, _pts[1].y/_vHeight)],
                           [NSValue valueWithCGPoint:CGPointMake(_pts[2].x/_vWidth, _pts[2].y/_vHeight)],
                           [NSValue valueWithCGPoint:CGPointMake(_pts[3].x/_vWidth, _pts[3].y/_vHeight)], nil];
        [self.delegate didAddPointsDel:points];
        
        _pts[0] = _pts[3];
        _pts[1] = _pts[4];
        _ctr = 1;
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self drawBitmap];
    [self setNeedsDisplay];
    [self.path removeAllPoints];
    _ctr = 0;
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
    _ctr = 0;
}

- (void)drawNewPoints:(NSArray *)points
{
    CGPoint p0 = [[points objectAtIndex:0] CGPointValue];
    CGPoint p1 = [[points objectAtIndex:1] CGPointValue];
    CGPoint p2 = [[points objectAtIndex:2] CGPointValue];
    CGPoint p3 = [[points objectAtIndex:3] CGPointValue];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.path moveToPoint:CGPointMake(p0.x * _vWidth, p0.y * _vHeight)];
        [self.path addCurveToPoint:CGPointMake(p3.x * _vWidth, p3.y * _vHeight)
                     controlPoint1:CGPointMake(p1.x * _vWidth, p1.y * _vHeight)
                     controlPoint2:CGPointMake(p2.x * _vWidth, p2.y * _vHeight)];
        [self setNeedsDisplay];
    });
}

@end
