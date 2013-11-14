//
//  SSQuestion.h
//  SSlide
//
//  Created by Le Van Nghia on 11/14/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SSQuestion : NSObject

@property (copy, nonatomic) NSString *content;
@property (assign, nonatomic) NSUInteger pageNum;

- (id)initWith:(NSString *)content pagenum:(NSUInteger)pagenum;

@end
