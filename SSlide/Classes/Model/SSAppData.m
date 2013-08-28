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
            sharedSSAppData.currentUser = [[SSUser alloc] initWith:@"defaultuser" password:nil];
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
    NSPredicate *predicate = [NSPredicate predicateWithBlock:^BOOL(SSSlideshow *evaluatedObj, NSDictionary *bind) {
        return [evaluatedObj.username isEqualToString:@"thefoolishman"];
    }];
    NSArray *downloaded = [self.downloadedSlides copy];
    NSArray *result = [downloaded filteredArrayUsingPredicate:predicate];
    return result;
}

- (BOOL)isLogined
{
    return self.currentUser && self.currentUser.username && self.currentUser.password;
}

@end
