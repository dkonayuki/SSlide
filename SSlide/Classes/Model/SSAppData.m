//
//  SSAppData.m
//  SSlide
//
//  Created by iNghia on 8/23/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import "SSAppData.h"

@implementation SSAppData

+(SSAppData *)sharedInstance
{
    __strong static SSAppData *sharedSSAppData = nil;
    static dispatch_once_t onceQueue = 0;
    dispatch_once(&onceQueue, ^{
        sharedSSAppData = [[SSAppData alloc] init];
        
        // load data
        NSString *directory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        // load user data
        NSString *filePath = [directory stringByAppendingPathComponent:@"SSUserData"];
        if ([fileManager fileExistsAtPath:filePath]) {
            sharedSSAppData.currentUser = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
            NSLog(@"OK! Data has been loaded from .dat file");
        } else {
            sharedSSAppData.currentUser = [[SSUser alloc] initDefaultUser];
        }
        
        // load downloaded slide data
        filePath = [directory stringByAppendingPathComponent:@"SSDownloadedSlideData"];
        if([fileManager fileExistsAtPath:filePath]) {
            sharedSSAppData.downloadedSlides = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
        } else {
            sharedSSAppData.downloadedSlides = [[NSMutableArray alloc] init];
            NSLog(@"init downloaded Slides");
        }
    });
    
    return sharedSSAppData;
}

+(void)saveAppData
{
    NSString *directory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // save user data
    NSString *filePath = [directory stringByAppendingPathComponent:@"SSUserData"];
    [NSKeyedArchiver archiveRootObject:[[self sharedInstance] currentUser] toFile:filePath];
    
    if ([fileManager fileExistsAtPath:filePath]) {
        NSLog(@"OK! User data has been successfully saved!");
    } else {
        NSLog(@"User data save failed");
    }
    
    // save slide data
    filePath = [directory stringByAppendingPathComponent:@"SSDownloadedSlideData"];
    [NSKeyedArchiver archiveRootObject:[[self sharedInstance] downloadedSlides] toFile:filePath];
    
    if ([fileManager fileExistsAtPath:filePath]) {
        NSLog(@"OK! Slide data has been successfully saved!");
    } else {
        NSLog(@"Slide data save failed");
    }
}

- (NSArray *)mySlides
{
    NSArray *downloaded = [self.downloadedSlides copy];
    return downloaded;
}

- (SSSlideshow *)getDownloadedSlide:(NSString *)slideId;
{
    for (SSSlideshow *s in [SSAppData sharedInstance].downloadedSlides) {
        if ([s.slideId isEqualToString:slideId]) {
            return s;
        }
    }
    return nil;
}

- (BOOL)isLogined
{
    return self.currentUser && self.currentUser.username && self.currentUser.password;
}

- (BOOL)deleteDownloadedSlideAtIndex:(NSUInteger)index
{
    SSSlideshow *willDeleteSlide = [self.downloadedSlides objectAtIndex:index];
    NSString *directory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSString *folderPath = [directory stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@", willDeleteSlide.slideId]];
    NSError *error;
    [fileManager removeItemAtPath:folderPath error:&error];
    if (error) {
        return FALSE;
    } else {
        [self.downloadedSlides removeObjectAtIndex:index];
        [SSAppData saveAppData];
        return TRUE;
    }
}

@end
