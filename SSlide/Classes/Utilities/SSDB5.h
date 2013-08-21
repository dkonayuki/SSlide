//
//  SSDB5.h
//  SSlide
//
//  Created by iNghia on 8/21/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <VSTheme.h>
#import <VSThemeLoader.h>

@interface SSDB5 : NSObject

@property (strong, nonatomic) VSThemeLoader *themeLoader;
@property (strong, nonatomic) VSTheme *theme;

+ (SSDB5 *)sharedInstance;
+ (VSTheme *)theme;

@end
