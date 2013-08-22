//
//  SSSlideshow.h
//  SSlide
//
//  Created by iNghia on 8/22/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SSSlideshow : NSObject

@property (copy, nonatomic) NSString *slideId;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *username;
@property (copy, nonatomic) NSString *url;
@property (copy, nonatomic) NSString *thumbnailUrl;
@property (copy, nonatomic) NSString *created;
@property (assign, nonatomic) NSInteger totalSlides;
@property (copy, nonatomic) NSString *slideImageBaseurl;
@property (copy, nonatomic) NSString *slideImageBaseurlSuffix;

- (void)log;

@end
