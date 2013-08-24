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
@synthesize isDownloaded = mIsDownloaded;
@synthesize localBasePath = mLocalBasePath;

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super init]) {
        mSlideId = [aDecoder decodeObjectForKey:@"mSlideId"];
        mTitle = [aDecoder decodeObjectForKey:@"mTitle"];
        mUsername = [aDecoder decodeObjectForKey:@"mUsername"];
        mUrl = [aDecoder decodeObjectForKey:@"mUrl"];
        mThumbnailUrl = [aDecoder decodeObjectForKey:@"mThumbnailUrl"];
        mCreated = [aDecoder decodeObjectForKey:@"mCreated"];
        
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
        self.isDownloaded = NO;
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
    return self.isDownloaded;
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
    
    NSMutableArray *operationsArray = [NSMutableArray array];
    for (int i = 1; i <= self.totalSlides; i++) {
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
                                                                float per = (float)numberOfFinishedOperations/(float)totalNumberOfOperations;
                                                                progress(per);
                                        } completionBlock:^(NSArray *operations) {
                                            self.isDownloaded = YES;
                                            [[SSAppData sharedInstance].downloadedSlides addObject:self];
                                            [SSAppData saveAppData];
                                            completion(YES);
                                        }];
}

@end
