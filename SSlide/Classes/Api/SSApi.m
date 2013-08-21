//
//  SSApi.m
//  SSlide
//
//  Created by iNghia on 8/22/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import "SSApi.h"
#import <NSString-Hashes/NSString+Hashes.h>
#import <XMLDictionary/XMLDictionary.h>
#import "SSDB5.h"

@implementation SSApi

+ (SSApi *)sharedInstance
{
    __strong static SSApi *sharedApi = nil;
    static dispatch_once_t onceQueue = 0;
    dispatch_once(&onceQueue, ^{
        sharedApi = [[SSApi alloc] init];
        sharedApi.baseURL = [NSURL URLWithString:[[SSDB5 theme] stringForKey:@"API_BASE_URL"]];
        sharedApi.client = [[AFHTTPClient alloc] initWithBaseURL:sharedApi.baseURL];
    });
    
    return sharedApi;
}

- (NSString *)getApiHash
{
    NSDate *now = [NSDate date];
    int ts = [now timeIntervalSince1970];
    NSString *apikey = [[SSDB5 theme] stringForKey:@"API_KEY"];;
    NSString *apisecrect = [[SSDB5 theme] stringForKey:@"API_SECRET"];
    NSString *hashString = [NSString stringWithFormat:@"%@%d", apisecrect, ts];
    NSString *hash = [hashString sha1];
    NSString *url = [NSString stringWithFormat:@"api_key=%@&hash=%@&ts=%d", apikey, hash, ts];
    return url;
}

- (void)search_slideshows:(NSString *)params success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure
{
    NSString *url = [NSString stringWithFormat:@"search_slideshows?%@&%@", params, [self getApiHash]];
    [self.client getPath:url
              parameters:nil
            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSDictionary *dictionary = [NSDictionary dictionaryWithXMLData:responseObject];
                success(operation, dictionary);
            }
            failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                failure(operation, error);
            }];
}

@end
