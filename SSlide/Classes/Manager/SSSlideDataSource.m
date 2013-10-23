//
//  SSSlideDataSource.m
//  SSlide
//
//  Created by iNghia on 9/10/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import "SSSlideDataSource.h"

@interface SSSlideDataSource()

@property (strong, nonatomic) NSMutableArray *slideArray;
@property (assign, nonatomic) NSInteger currentPage;

@end

@implementation SSSlideDataSource

- (id)init
{
    self = [super init];
    if (self) {
        [self resetDataSource];
    }
    return self;
}

- (NSUInteger)slideSum
{
    return self.slideArray.count;
}

- (NSUInteger)nextPageNum
{
    return self.currentPage + 1;
}

- (NSUInteger)currentPageNum
{
    return self.currentPage;
}

- (SSSlideshow *)slideAtIndex:(NSUInteger)index
{
    return [self.slideArray objectAtIndex:index];
}

- (void)resetDataSource
{
    self.currentPage = 1;
    self.slideArray = [[NSMutableArray alloc] init];
}

- (void)resetBySlideArray:(NSMutableArray *)slides
{
    self.slideArray = slides;
}

- (void)addSlidesFromArray:(NSArray *)newSlides
{
    self.currentPage ++;
    [self.slideArray addObjectsFromArray:newSlides];
}

- (void)addSlide:(SSSlideshow *)newSlide
{
    [self.slideArray addObject:newSlide];
}

@end
