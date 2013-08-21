//
//  SSDB5.m
//  SSlide
//
//  Created by iNghia on 8/21/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import "SSDB5.h"

@implementation SSDB5

+ (SSDB5 *)sharedInstance
{
    __strong static SSDB5 *sharedDB5 = nil;
    static dispatch_once_t onceQueue = 0;
    dispatch_once(&onceQueue, ^{
        sharedDB5 = [[SSDB5 alloc] init];
        sharedDB5.themeLoader = [VSThemeLoader new];
        sharedDB5.theme = sharedDB5.themeLoader.defaultTheme;
    });

    return sharedDB5;
}

+ (VSTheme *)theme
{
    return [[self sharedInstance] theme];
}

@end
