//
//  SSSlidePageCacheManager.m
//  SSlide
//
//  Created by iNghia on 10/18/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import "SSSlidePageCacheManager.h"

@interface SSSlidePageCacheManager()

@property (strong, nonatomic) NSMutableDictionary *cachedViewControllerDic;
@property (assign, nonatomic) NSUInteger minCachedPageNum;
@property (assign, nonatomic) NSUInteger maxCachedPageNum;
@property (assign, nonatomic) NSUInteger lastLoadedPageNum;
@property (strong, nonatomic) SSSlideshow *currentSlideshow;
@property (assign, nonatomic) NSUInteger totalPage;

@end

@implementation SSSlidePageCacheManager

- (id)initWithCurrentSlideshow:(SSSlideshow *)currentSlideshow delegate:(id)delegate
{
    if (self = [super init]) {
        self.delegate = delegate;
        self.currentSlideshow = currentSlideshow;
        self.totalPage = self.currentSlideshow.totalSlides;
        self.cachedViewControllerDic = [[NSMutableDictionary alloc] init];
        self.minCachedPageNum = 1;
        self.maxCachedPageNum = 1;
        self.lastLoadedPageNum = 1;
    }
    return self;
}

- (SSSlideShowViewController *)viewControllerAtIndex:(NSUInteger)index
{
    SSSlideShowViewController *targetSlideShowViewController = [self loadViewControllerAtIndex:index];
    
    // download around
    if (index == 1) {
        while ((self.maxCachedPageNum < 5) && (self.maxCachedPageNum < self.totalPage)) {
            self.maxCachedPageNum ++;
            [self loadViewControllerAtIndex:self.maxCachedPageNum];
        }
    } else {
        if (self.lastLoadedPageNum < index)
        {
            if((self.maxCachedPageNum <= index + 2) && (self.maxCachedPageNum < self.totalPage)) {
                // add new max
                [self loadViewControllerAtIndex:self.maxCachedPageNum + 1];
                // remove min
                NSLog(@"REMOVE SLIDE NUM: %d", self.minCachedPageNum);
                [self.cachedViewControllerDic removeObjectForKey:[NSNumber numberWithInt:self.minCachedPageNum]];
                self.minCachedPageNum ++;
                [self logCachedPagenums];
            }
        }else {
            if((self.minCachedPageNum > 1) && (self.minCachedPageNum >= index -2)) {
                // add new min
                [self loadViewControllerAtIndex:self.minCachedPageNum - 1];
                // remove max
                NSLog(@"REMOVE SLIDE NUM: %d", self.maxCachedPageNum);
                [self.cachedViewControllerDic removeObjectForKey:[NSNumber numberWithInt:self.maxCachedPageNum]];
                self.maxCachedPageNum --;
                [self logCachedPagenums];
            }
        }
    }
    
    self.lastLoadedPageNum = index;
    return targetSlideShowViewController;
}


#pragma mark - private
- (SSSlideShowViewController *)loadViewControllerAtIndex:(NSUInteger)index
{
    SSSlideShowViewController *targetSlideShowViewController = [self.cachedViewControllerDic objectForKey:[NSNumber numberWithInt:index]];
    if(targetSlideShowViewController == nil) {
        NSLog(@"LOAD NEW SLIDE NUM: %d", index);
        targetSlideShowViewController = [[SSSlideShowViewController alloc] initWithCurrentSlideshow:self.currentSlideshow
                                                                                          pageIndex:index
                                                                                        andDelegate:self.delegate];
        [self.cachedViewControllerDic setObject:targetSlideShowViewController forKey:[NSNumber numberWithInt:index]];
        if (self.minCachedPageNum > index) {
            self.minCachedPageNum = index;
        }
        if (self.maxCachedPageNum < index) {
            self.maxCachedPageNum = index;
        }
        [self logCachedPagenums];
    }
    return targetSlideShowViewController;
}

- (void)logCachedPagenums
{
    NSMutableString *list = [NSMutableString stringWithString:@"Cached: "];
    for (NSNumber *pageNum in self.cachedViewControllerDic) {
        [list appendString:[NSString stringWithFormat:@" %d ", pageNum.intValue]];
    }
    NSLog(@"%@", list);
}

@end
