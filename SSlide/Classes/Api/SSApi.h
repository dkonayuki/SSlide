//
//  SSApi.h
//  SSlide
//
//  Created by iNghia on 8/22/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>

@interface SSApi : NSObject

@property (strong, nonatomic) NSURL *baseURL;
@property (strong, nonatomic) AFHTTPClient *client;

- (void)getSlideshowsByUser:(NSString *)username success:(void (^)(NSArray *result))success failure:(void (^)())failure;
- (void)searchSlideshows:(NSString *)params success:(void (^)(NSArray *result))success failure:(void (^)())failure;

+ (SSApi *)sharedInstance;

@end

