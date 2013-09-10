//
//  SSAdManager.h
//  SSlide
//
//  Created by iNghia on 9/10/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <iAd/iAd.h>

@interface SSAdManager : NSObject

@property (strong, nonatomic) ADBannerView *iAdView;

- (id)initWithAdFrame:(CGRect)frame;

@end
