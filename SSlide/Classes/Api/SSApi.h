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

/**
 *	check username and password
 *
 *	@param	username
 *	@param	password
 */
- (void)checkUsernamePassword:(NSString *)username password:(NSString *)password result:(void (^)(BOOL result))result;

/**
 *	get slideshows by user
 *
 *	@param	username
 */
- (void)getSlideshowsByUser:(NSString *)username success:(void (^)(NSArray *result))success failure:(void (^)())failure;

/**
 *	search slideshows
 *
 *	@param	params
 */
- (void)searchSlideshows:(NSString *)params success:(void (^)(NSArray *result))success failure:(void (^)())failure;

/**
 *	get extended slide info
 *
 *	@param	url
 */
- (void)getExtendedSlideInfo:(NSString *)url;

/**
 *	get singleton
 *
 *	@return singleton object
 */
+ (SSApi *)sharedInstance;

@end

