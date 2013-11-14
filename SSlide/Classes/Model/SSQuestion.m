//
//  SSQuestion.m
//  SSlide
//
//  Created by Le Van Nghia on 11/14/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import "SSQuestion.h"

@implementation SSQuestion

- (id)initWith:(NSString *)content pagenum:(NSUInteger)pagenum
{
    self = [super init];
    
    if(self) {
        self.content = content;
        self.pageNum = pagenum;
    }
    
    return self;
}

- (id)initWith:(NSString *)quesId content:(NSString *)content pagenum:(NSUInteger)pagenum voteNum:(NSUInteger)voteNum
{
    self = [super init];
    
    if(self) {
        self.questionId = quesId;
        self.content = content;
        self.pageNum = pagenum;
        self.voteNum = voteNum;
    }
    
    return self;
}

@end
