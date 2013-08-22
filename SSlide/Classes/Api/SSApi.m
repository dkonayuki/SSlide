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

- (void)search_slideshows:(NSString *)params success:(void (^)(NSArray *))success failure:(void (^)())failure
{
    self.slideshowArray = [[NSMutableArray alloc] init];
    self.currentSlideshow = nil;
    NSString *url = [NSString stringWithFormat:@"search_slideshows?%@&%@", params, [self getApiHash]];
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

- (void)traverseSlideshows:(TBXMLElement *)element {
    do {
        // Display the name of the element
        NSString *elementName = [TBXML elementName:element];
        //NSLog(@"%@", elementName);
        if ([elementName isEqualToString:@"Slideshow"]) {
            self.currentSlideshow = [[SSSlideshow alloc] init];
        } else if ([elementName isEqualToString:@"ID"]) {
            self.currentSlideshow.ID = [TBXML textForElement:element];
        } else if ([elementName isEqualToString:@"Title"]) {
            self.currentSlideshow.Title = [TBXML textForElement:element];
        } else if ([elementName isEqualToString:@"Username"]) {
            self.currentSlideshow.Username = [TBXML textForElement:element];
        } else if ([elementName isEqualToString:@"URL"]) {
            self.currentSlideshow.URL = [TBXML textForElement:element];
        } else if ([elementName isEqualToString:@"ThumbnailURL"]) {
            self.currentSlideshow.ThumbnailURL = [TBXML textForElement:element];
        } else if ([elementName isEqualToString:@"Created"]) {
            self.currentSlideshow.Created = [TBXML textForElement:element];
            [self.slideshowArray addObject:self.currentSlideshow];
        }
        
        // if the element has child elements, process them
        if (element->firstChild)
            [self traverseSlideshows:element->firstChild];
        
        // Obtain next sibling element
    } while ((element = element->nextSibling));
}

@end
