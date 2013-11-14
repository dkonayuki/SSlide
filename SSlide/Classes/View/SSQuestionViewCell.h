//
//  SSQuestionViewCell.h
//  SSlide
//
//  Created by Le Van Nghia on 11/15/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import <RMSwipeTableViewCell/RMSwipeTableViewCell.h>

@interface SSQuestionViewCell : RMSwipeTableViewCell


@property (strong, nonatomic) UIImageView *voteUpImageView;
@property (strong, nonatomic) UIImageView *voteDownImageView;
@property (assign, nonatomic) NSUInteger voteState;

@end
