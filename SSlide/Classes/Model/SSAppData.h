//
//  SSAppData.h
//  SSlide
//
//  Created by iNghia on 8/23/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSUser.h"
#import "SSSlideshow.h"

@interface SSAppData : NSObject

@property (strong, nonatomic) SSUser *currentUser;
@property (strong, nonatomic) NSMutableArray *downloadedSlides;

- (NSArray *)mySlides;

+ (SSAppData *)sharedInstance;
+ (void)saveAppData;

@end
