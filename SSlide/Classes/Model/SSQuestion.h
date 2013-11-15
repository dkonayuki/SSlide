//
//  SSQuestion.h
//  SSlide
//
//  Created by Le Van Nghia on 11/14/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import <Foundation/Foundation.h>

enum {
    VOTE_UP = 1,
    VOTE_DOWN = -1,
    VOTE_NONE = 0,
};

@interface SSQuestion : NSObject

@property (copy, nonatomic) NSString *questionId;
@property (copy, nonatomic) NSString *content;
@property (assign, nonatomic) NSUInteger pageNum;
@property (assign, nonatomic) NSUInteger voteNum;
@property (assign, nonatomic) NSUInteger voteStatus;

- (id)initWith:(NSString *)content pagenum:(NSUInteger)pagenum;
- (id)initWith:(NSString *)quesId content:(NSString *)content pagenum:(NSUInteger)pagenum voteNum:(NSUInteger)voteNum voteStatus:(NSUInteger)status;

@end
