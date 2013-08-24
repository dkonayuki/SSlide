//
//  SSApi.m
//  SSlide
//
//  Created by iNghia on 8/22/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import "SSApi.h"
#import <NSString-Hashes/NSString+Hashes.h>
#import <TBXML/TBXML.h>
#import <TBXML+NSDictionary/TBXML+NSDictionary.h>
#import "SSDB5.h"
#import "SSSlideshow.h"

@interface SSApi()

@property (strong, nonatomic) NSMutableArray *slideshowArray;
@property (strong, nonatomic) SSSlideshow *currentSlideshow;

@end

@implementation SSApi

/**
 *	Singleton
 *
 *	@return	sharedInstance
 */
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

/**
 *	get slideshows by username
 *
 *	@param	username
 */
- (void)getSlideshowsByUser:(NSString *)username page:(int)page success:(void (^)(NSArray *))success failure:(void (^)())failure
{
    self.slideshowArray = [[NSMutableArray alloc] init];
    self.currentSlideshow = nil;
    int itemsInPage = [[SSDB5 theme] integerForKey:@"slide_num_in_page"];
    int offset = itemsInPage*(page-1);
    NSString *url = [NSString stringWithFormat:@"get_slideshows_by_user?detailed=1&username_for=%@&limit=%d&offset=%d&%@", username, itemsInPage, offset, [self getApiHash]];
    [self.client getPath:url
              parameters:nil
                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                     NSError *error = nil;
                     TBXML *tbxml = [TBXML tbxmlWithXMLData:responseObject error:&error];
                     if (tbxml.rootXMLElement) {
                         [self traverseSlideshows:tbxml.rootXMLElement];
                         success(self.slideshowArray);
                     }
                 }
                 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                     failure();
                 }];
}

/**
 *	search slideshows
 *
 *	@param	params
 */
- (void)searchSlideshows:(NSString *)params success:(void (^)(NSArray *))success failure:(void (^)())failure
{
    NSString *paramsEncoding = [params stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"paramsEncoding: %@", paramsEncoding);
    self.slideshowArray = [[NSMutableArray alloc] init];
    self.currentSlideshow = nil;
    NSString *url = [NSString stringWithFormat:@"search_slideshows?detailed=1&%@&%@", paramsEncoding, [self getApiHash]];
    [self.client getPath:url
              parameters:nil
            success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSError *error = nil;
//                NSDictionary *dict = [TBXML dictionaryWithXMLData:responseObject error:&error];
//                if (!error) {
//                    NSArray *slideshows = [dict objectForKey:@"Slideshow"];
//                    NSLog(@"%d: ", [slideshows count]);
//                } else {  // error handling
//                    NSLog(@"parsing ERROR");
//                }
                TBXML *tbxml = [TBXML tbxmlWithXMLData:responseObject error:&error];
                if (tbxml.rootXMLElement) {
                    [self traverseSlideshows:tbxml.rootXMLElement];
                    success(self.slideshowArray);
                }
            }
            failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                failure();
            }];
}

/**
 *	get most Viewed Slideshows
 *
 *	@param	tag
 *	@param	page
 *	@param	itemsPerPage
 */
- (void)getMostViewedSlideshows:(NSString *)tag page:(int)page itemsPerPage:(int)itemsPerPage success:(void (^)(NSArray *))success failure:(void (^)())failure
{
    NSString *query = [NSString stringWithFormat:@"q=%@&page=%d&items_per_page=%d&sort=mostviewed&what=tag", tag, page, itemsPerPage];
    [self searchSlideshows:query success:success failure:failure];
}

/**
 *	get latest Slideshow
 *
 *	@param	tag
 *	@param	page
 *	@param	itemsPerPage
 */
- (void)getLatestSlideshows:(NSString *)tag page:(int)page itemsPerPage:(int)itemsPerPage success:(void (^)(NSArray *))success failure:(void (^)())failure
{
    NSString *query = [NSString stringWithFormat:@"q=%@&page=%d&items_per_page=%d&sort=latest&what=tag", tag, page, itemsPerPage];
    [self searchSlideshows:query success:success failure:failure];
}

/**
 *	check username and password
 *
 *	@param	username
 *	@param	password
 *
 *	@return	authenticate result
 */
- (void)checkUsernamePassword:(NSString *)username password:(NSString *)password result:(void (^)(BOOL))result
{
    NSString *url = [NSString stringWithFormat:@"get_user_leads?username=%@&password=%@&%@", username, password,  [self getApiHash]];
    [self.client getPath:url
              parameters:nil
                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                     NSError *error = nil;
                     TBXML *tbxml = [TBXML tbxmlWithXMLData:responseObject error:&error];
                     NSString *rootElementName = [TBXML elementName:tbxml.rootXMLElement];
                     if (![rootElementName isEqualToString:@"SlideShareServiceError"]) {
                         result(YES);
                     }else {
                         result(NO);
                     }
                 }
                 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                     result(NO);
                 }];
}

/**
 *	get extended slide info
 *
 *	@param	url
 */
- (void)getExtendedSlideInfo:(NSString *)url
{
    NSString *requestUrl = [NSString stringWithFormat:@"%@?url=%@&format=json", [[SSDB5 theme] stringForKey:@"OEMBED_BASE_URL"], url];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestUrl]];
    
    AFJSONRequestOperation *operation =
    [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                    success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                        NSDictionary *dict = (NSDictionary *)JSON;
                                                        NSLog(@"OK");
                                                        NSLog(@"%@", dict);
                                                    }
                                                    failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                        NSLog(@"error");
                                                    }];
    [operation start];
}

/**
 *	add Extended Slide info
 *
 *	@param	slide
 */
- (void)addExtendedSlideInfo:(SSSlideshow *)slide result:(void (^)(BOOL))result
{
    __block SSSlideshow *curSlide = slide;
    NSString *requestUrl = [NSString stringWithFormat:@"%@?url=%@&format=json", [[SSDB5 theme] stringForKey:@"OEMBED_BASE_URL"], slide.url];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:requestUrl]];
    
    AFJSONRequestOperation *operation =
    [AFJSONRequestOperation JSONRequestOperationWithRequest:request
                                                    success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                                                        NSDictionary *dict = (NSDictionary *)JSON;
                                                        NSString *totalSlides = (NSString *)[dict objectForKey:@"total_slides"];
                                                        
                                                        curSlide.totalSlides = [totalSlides integerValue];
                                                        curSlide.slideImageBaseurl = [dict objectForKey:@"slide_image_baseurl"];
                                                        curSlide.slideImageBaseurlSuffix = [dict objectForKey:@"slide_image_baseurl_suffix"];
                                                        NSString *firstImageUrl = [NSString stringWithFormat:@"http:%@1%@", curSlide.slideImageBaseurl, curSlide.slideImageBaseurlSuffix];
                                                        curSlide.firstPageImageUrl = firstImageUrl;
                                                       // [curSlide log];
                                                        result(TRUE);
                                                    }
                                                    failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                                                        result(FALSE);
                                                    }];
    
    [operation start];
}

#pragma mark - private

/**
 *	trarse xml
 *
 *	@param	element	(root element)
 */
- (void)traverseSlideshows:(TBXMLElement *)element {
    do {
        // Display the name of the element
        NSString *elementName = [TBXML elementName:element];
        //NSLog(@"%@", elementName);
        if ([elementName isEqualToString:@"Slideshow"]) {
            self.currentSlideshow = [[SSSlideshow alloc] initWithDefaultData];
        } else if ([elementName isEqualToString:@"ID"]) {
            self.currentSlideshow.slideId = [TBXML textForElement:element];
        } else if ([elementName isEqualToString:@"Title"]) {
            self.currentSlideshow.title = [TBXML textForElement:element];
        } else if ([elementName isEqualToString:@"Username"]) {
            self.currentSlideshow.username = [TBXML textForElement:element];
        } else if ([elementName isEqualToString:@"URL"]) {
            self.currentSlideshow.url = [TBXML textForElement:element];
        } else if ([elementName isEqualToString:@"ThumbnailURL"]) {
            self.currentSlideshow.thumbnailUrl = [TBXML textForElement:element];
        } else if ([elementName isEqualToString:@"Created"]) {
            self.currentSlideshow.created = [TBXML textForElement:element];
        } else if ([elementName isEqualToString:@"NumDownloads"]) {
            self.currentSlideshow.numDownloads = [[TBXML textForElement:element] integerValue];
        } else if ([elementName isEqualToString:@"NumViews"]) {
            self.currentSlideshow.numViews = [[TBXML textForElement:element] integerValue];
        } else if ([elementName isEqualToString:@"NumFavorites"]) {
            self.currentSlideshow.numFavorites = [[TBXML textForElement:element] integerValue];
        }else if ([elementName isEqualToString:@"NumSlides"]) {
            self.currentSlideshow.totalSlides = [[TBXML textForElement:element] integerValue];
            [self.slideshowArray addObject:self.currentSlideshow];
            [self.currentSlideshow log];
        }
        
        // if the element has child elements, process them
        if (element->firstChild)
            [self traverseSlideshows:element->firstChild];
        
        // Obtain next sibling element
    } while ((element = element->nextSibling));
}

/**
 *	getApiHash
 *
 *	@return	apiHash
 */
- (NSString *)getApiHash
{
    NSDate *now = [NSDate date];
    int ts = [now timeIntervalSince1970];
    NSString *apikey = [[SSDB5 theme] stringForKey:@"API_KEY"];;
    NSString *apisecrect = [[SSDB5 theme] stringForKey:@"API_SECRET"];
    NSString *hashString = [NSString stringWithFormat:@"%@%d", apisecrect, ts];
    NSString *hash = [hashString sha1];
    NSString *apiHash = [NSString stringWithFormat:@"api_key=%@&hash=%@&ts=%d", apikey, hash, ts];
    return apiHash;
}

@end
