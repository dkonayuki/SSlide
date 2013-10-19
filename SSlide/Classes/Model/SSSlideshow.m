//
//  SSSlideshow.m
//  SSlide
//
//  Created by iNghia on 8/22/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import "SSSlideshow.h"
#import <AFNetworking/AFImageRequestOperation.h>
#import "SSAppData.h"
#import <NSString-HTML/NSString+HTML.h>
#import "SSApi.h"

@interface SSSlideshow()

@property (assign, nonatomic) BOOL isDownloaded;
@property (copy, nonatomic) NSString *localBasePath;
@property (assign) NSUInteger downloadedNum;

@end

@implementation SSSlideshow
@synthesize slideId = mSlideId;
@synthesize title = mTitle;
@synthesize username = mUsername;
@synthesize url = mUrl;
@synthesize thumbnailUrl = mThumbnailUrl;
@synthesize created = mCreated;
@synthesize numDownloads = mNumDownloads;
@synthesize numViews = mNumViews;
@synthesize numFavorites = mNumFavorites;
@synthesize totalSlides = mTotalSlides;
@synthesize slideImageBaseurl = mSlideImageBaseurl;
@synthesize slideImageBaseurlSuffix = mSlideImageBaseurlSuffix;
@synthesize firstPageImageUrl = mFirstPageImageUrl;
@synthesize localBasePath = mLocalBasePath;
@synthesize isDownloaded = mIsDownloaded;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super init]) {
        mSlideId = [aDecoder decodeObjectForKey:@"mSlideId"];
        mTitle = [aDecoder decodeObjectForKey:@"mTitle"];
        mUsername = [aDecoder decodeObjectForKey:@"mUsername"];
        mUrl = [aDecoder decodeObjectForKey:@"mUrl"];
        mThumbnailUrl = [aDecoder decodeObjectForKey:@"mThumbnailUrl"];
        mCreated = [aDecoder decodeObjectForKey:@"mCreated"];
        
        mTotalSlides = [aDecoder decodeIntegerForKey:@"mTotalSlides"];
        mNumDownloads = [aDecoder decodeIntegerForKey:@"mNumDownloads"];
        mNumViews = [aDecoder decodeIntegerForKey:@"mNumViews"];
        mNumFavorites = [aDecoder decodeIntegerForKey:@"mNumFavorites"];
        
        mSlideImageBaseurl = [aDecoder decodeObjectForKey:@"mSlideImageBaseurl"];
        mSlideImageBaseurlSuffix = [aDecoder decodeObjectForKey:@"mSlideImageBaseurlSuffix"];
        mFirstPageImageUrl = [aDecoder decodeObjectForKey:@"mFirstPageImageUrl"];
        
        mIsDownloaded = [aDecoder decodeBoolForKey:@"mIsDownloaded"];
        mLocalBasePath = [aDecoder decodeObjectForKey:@"mLocalBasePath"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:mSlideId forKey:@"mSlideId"];
    [aCoder encodeObject:mTitle forKey:@"mTitle"];
    [aCoder encodeObject:mUsername forKey:@"mUsername"];
    [aCoder encodeObject:mUrl forKey:@"mUrl"];
    [aCoder encodeObject:mThumbnailUrl forKey:@"mThumbnailUrl"];
    [aCoder encodeObject:mCreated forKey:@"mCreated"];
    
    [aCoder encodeInteger:mTotalSlides forKey:@"mTotalSlides"];
    [aCoder encodeInteger:mNumDownloads forKey:@"mNumDownloads"];
    [aCoder encodeInteger:mNumViews forKey:@"mNumViews"];
    [aCoder encodeInteger:mNumFavorites forKey:@"mNumFavorites"];
    
    [aCoder encodeObject:mSlideImageBaseurl forKey:@"mSlideImageBaseurl"];
    [aCoder encodeObject:mSlideImageBaseurlSuffix forKey:@"mSlideImageBaseurlSuffix"];
    [aCoder encodeObject:mFirstPageImageUrl forKey:@"mFirstPageImageUrl"];
    
    [aCoder encodeBool:mIsDownloaded forKey:@"mIsDownloaded"];
    [aCoder encodeObject:mLocalBasePath forKey:@"mLocalBasePath"];
}

- (id)initWithDefaultData
{
    self = [super init];
    if (self) {
        mIsDownloaded = NO;
    }
    return self;
}

- (void)setTitle:(NSString *)title
{
    mTitle = [title kv_decodeHTMLCharacterEntities];
}

- (void)setThumbnailUrl:(NSString *)thumbnailUrl
{
    mThumbnailUrl = [NSString stringWithFormat:@"http:%@", thumbnailUrl];
}

- (void)setCreated:(NSString *)created
{
    NSArray *comp = [created componentsSeparatedByString:@" "];
    NSString *date = [comp objectAtIndex:2];
    NSString *month = [comp objectAtIndex:1];
    NSString *year = [comp objectAtIndex:5];
    mCreated = [NSString stringWithFormat:@"%@ %@ %@", date, month, year];
}

- (void)setSlideImageBaseurl:(NSString *)slideImageBaseurl
{
    mSlideImageBaseurl = [NSString stringWithFormat:@"http:%@", slideImageBaseurl];
}

- (void)setNormalCreated:(NSString *)created
{
    mCreated = created;
}

- (void)setNormalThumbnailUrl:(NSString *)thumbnailUrl
{
    mThumbnailUrl = thumbnailUrl;
}

- (void)setNormalSlideImageBaseurl:(NSString *)slideImageBaseurl
{
    mSlideImageBaseurl = slideImageBaseurl;
}

- (void)log
{
    NSLog(@"ID: %@", self.slideId);
    NSLog(@"Title: %@", self.title);
    NSLog(@"Username: %@", self.username);
    NSLog(@"URL: %@", self.url);
    NSLog(@"ThumbnailURL: %@", self.thumbnailUrl);
    NSLog(@"Created: %@", self.created);
    NSLog(@"Num Download: %d", self.numDownloads);
    NSLog(@"Num Views: %d", self.numViews);
    NSLog(@"Num Favorites: %d", self.numFavorites);
    NSLog(@"Total slides: %d", self.totalSlides);
    NSLog(@"Base url: %@", self.slideImageBaseurl);
    NSLog(@"Base url suffix: %@", self.slideImageBaseurlSuffix);
    NSLog(@"First page image url: %@", self.firstPageImageUrl);
}

- (BOOL)extendedInfoIsNil
{
    if (self.slideImageBaseurl && self.slideImageBaseurlSuffix) {
        return NO;
    }
    return YES;
}

- (BOOL)checkIsDownloaded
{
    return mIsDownloaded;
}

- (BOOL)checkIsDownloadedAsNew
{
    for (SSSlideshow *s in [SSAppData sharedInstance].downloadedSlides) {
        if ([s.slideId isEqualToString:self.slideId]) {
            return YES;
        }
    }
    return NO;
}

- (NSString *)remoteUrlOfImageAtPage:(NSUInteger)index
{
    NSString *url = [NSString stringWithFormat:@"%@%d%@", self.slideImageBaseurl, index, self.slideImageBaseurlSuffix];
    return url;
}

- (NSString *)localUrlOfImageAtPage:(NSUInteger)index
{
    return [NSString stringWithFormat:@"%@/%d.png", self.localBasePath, index];
}

- (void)download:(void (^)(float))progress completion:(void (^)(BOOL))completion
{
    NSString *directory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *folderPath = [directory stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@", self.slideId]];
    
    if (![fileManager fileExistsAtPath:folderPath]) {
        NSLog(@"Create new folder");
        [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:NO attributes:nil error:nil];
    }
    
    self.localBasePath = folderPath;
    
    self.downloadedNum = 0;
    [self downloadPart:0 pregress:progress completion:completion];
}
            
- (void)downloadPart:(int)fromPart pregress:(void (^)(float))progress completion:(void (^)(BOOL))completion
{
    int numItemsAsync = 15;
    int from = fromPart * numItemsAsync + 1;
    int to = MIN(from + numItemsAsync, self.totalSlides + 1);
    
    NSMutableArray *operationsArray = [NSMutableArray array];
    
    for (int i = from; i < to; i++) {
        NSString *filePath = [self localUrlOfImageAtPage:i];
        NSString *url = [self remoteUrlOfImageAtPage:i];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
        AFImageRequestOperation *operation =
        [AFImageRequestOperation imageRequestOperationWithRequest:request
                                                          success:^(UIImage *image) {
                                                              [UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES];
                                                          }];
        [operationsArray addObject:operation];
    }
    
    [[[SSApi sharedInstance] client]  enqueueBatchOfHTTPRequestOperations:operationsArray
                                                            progressBlock:^(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations) {
                                                                int downloaded = numberOfFinishedOperations + self.downloadedNum;
                                                                float per = (float)downloaded/(float)self.totalSlides;
                                                                progress(per);
                                                            } completionBlock:^(NSArray *operations) {
                                                                self.downloadedNum += [operations count];
                                                                NSLog(@"finish: %d, %d, %d", [operations count], self.downloadedNum, self.totalSlides);
                                                                NSLog(@"part = %d", fromPart);
                                                                if (self.downloadedNum >= self.totalSlides) {
                                                                    self.isDownloaded = YES;
                                                                    [[SSAppData sharedInstance].downloadedSlides addObject:self];
                                                                    [SSAppData saveAppData];
                                                                    completion(YES);
                                                                } else {
                                                                    [self downloadPart:(fromPart + 1) pregress:progress completion:completion];
                                                                }
                                                            }];
}


- (void)assignDataFromDictionary:(NSDictionary *)dic
{
    self.username = [dic objectForKey:@"username"];
    self.slideId = [dic objectForKey:@"slideId"];
    self.title = [dic objectForKey:@"title"];
    [self setNormalThumbnailUrl:[dic objectForKey:@"thumbnailUrl"]];
    [self setNormalCreated:[dic objectForKey:@"created"]];
    self.numViews = [((NSNumber *)[dic objectForKey:@"numViews"]) intValue];
    self.numDownloads = [((NSNumber *)[dic objectForKey:@"numDownloads"]) intValue];
    self.numFavorites = [((NSNumber *)[dic objectForKey:@"numFavarites"]) intValue];
    self.totalSlides = [((NSNumber *)[dic objectForKey:@"totalSlides"]) intValue];
    [self setSlideImageBaseurl:[dic objectForKey:@"slideImageBaseurl"]];
    
    self.slideImageBaseurlSuffix = [dic objectForKey:@"slideImageBaseurlSuffix"];
    
    NSString *firstImageUrl = [NSString stringWithFormat:@"%@1%@", self.slideImageBaseurl, self.slideImageBaseurlSuffix];
    self.firstPageImageUrl = firstImageUrl;
    
    self.channel = [dic objectForKey:@"channel"];
}

@end
