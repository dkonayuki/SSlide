//
//  SSApi.h
//  SSlide
//
//  Created by iNghia on 8/22/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import "SSSlideshow.h"

@interface SSApi : NSObject

@property (strong, nonatomic) NSURL *baseURL;
@property (strong, nonatomic) AFHTTPClient *client;


- (void)checkUsernamePassword:(NSString *)username password:(NSString *)password result:(void (^)(BOOL result))result;

- (void)getSlideshowsByUser:(NSString *)username success:(void (^)(NSArray *result))success failure:(void (^)())failure;

- (void)searchSlideshows:(NSString *)params success:(void (^)(NSArray *result))success failure:(void (^)())failure;

- (void)getMostViewedSlideshows:(NSString *)tag page:(int)page itemsPerPage:(int)itemsPerPage success:(void (^)(NSArray *result))success failure:(void (^)())failure;

- (void)getLatestSlideshows:(NSString *)tag page:(int)page itemsPerPage:(int)itemsPerPage success:(void (^)(NSArray *result))success failure:(void (^)())failure;


- (void)getExtendedSlideInfo:(NSString *)url;
- (void)addExtendedSlideInfo:(SSSlideshow *)slide result:(void (^)(BOOL result))result;

/**
 *	get singleton
 *
 *	@return singleton object
 */
+ (SSApi *)sharedInstance;

@end

