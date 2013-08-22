//
//  SSSlideshow.h
//  SSlide
//
//  Created by iNghia on 8/22/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SSSlideshow : NSObject

@property (copy, nonatomic) NSString *ID;
@property (copy, nonatomic) NSString *Title;
@property (copy, nonatomic) NSString *Username;
@property (copy, nonatomic) NSString *URL;
@property (copy, nonatomic) NSString *ThumbnailURL;
@property (copy, nonatomic) NSString *Created;

- (void)log;

@end
