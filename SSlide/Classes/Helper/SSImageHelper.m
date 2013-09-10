//
//  SSImageHelper.m
//  SSlide
//
//  Created by iNghia on 9/11/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import "SSImageHelper.h"
#import <QuartzCore/QuartzCore.h>

@implementation SSImageHelper

+ (UIImage *) imageFromColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

@end
