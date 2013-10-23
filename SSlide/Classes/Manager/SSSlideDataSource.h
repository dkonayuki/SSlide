//
//  SSSlideDataSource.h
//  SSlide
//
//  Created by iNghia on 9/10/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSSlideshow.h"

@interface SSSlideDataSource : NSObject

- (NSUInteger)slideSum;
- (NSUInteger)nextPageNum;
- (NSUInteger)currentPageNum;

- (SSSlideshow *)slideAtIndex:(NSUInteger)index;

- (void)resetDataSource;
- (void)resetBySlideArray:(NSMutableArray *)slides;
- (void)addSlidesFromArray:(NSArray *)newSlides;
- (void)addSlide:(SSSlideshow *)newSlide;

@end
