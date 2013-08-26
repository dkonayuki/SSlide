//
//  SSSlideshow.h
//  SSlide
//
//  Created by iNghia on 8/22/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SSSlideshow : NSObject <NSCoding>

@property (copy, nonatomic) NSString *slideId;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *username;
@property (copy, nonatomic) NSString *url;
@property (copy, nonatomic) NSString *thumbnailUrl;
@property (copy, nonatomic) NSString *created;
@property (assign, nonatomic) NSInteger numDownloads;
@property (assign, nonatomic) NSInteger numViews;
@property (assign, nonatomic) NSInteger numFavorites;
@property (assign, nonatomic) NSInteger totalSlides;
@property (copy, nonatomic) NSString *slideImageBaseurl;
@property (copy, nonatomic) NSString *slideImageBaseurlSuffix;
@property (copy, nonatomic) NSString *firstPageImageUrl;

@property (copy, nonatomic) NSString *channel;

- (id)initWithDefaultData;

- (void)setNormalCreated:(NSString *)created;
- (void)setNormalThumbnailUrl:(NSString *)thumbnailUrl;
- (void)setNormalSlideImageBaseurl:(NSString *)slideImageBaseurl;

- (void)log;
- (BOOL)extendedInfoIsNil;

- (BOOL)checkIsDownloaded;

- (void)download:(void (^)(float percent))progress completion:(void (^)(BOOL result))completion;

- (NSString *)remoteUrlOfImageAtPage:(NSUInteger)index;
- (NSString *)localUrlOfImageAtPage:(NSUInteger)index;

@end
