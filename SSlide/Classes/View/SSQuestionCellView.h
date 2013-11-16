//
//  SSQuestionCellView.h
//  SSlide
//
//  Created by Le Van Nghia on 11/15/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import <RMSwipeTableViewCell/RMSwipeTableViewCell.h>

@protocol SSQuestionCellViewDelegate <NSObject>

- (void)voteUpQuestion:(NSString *)questionId;
- (void)voteDownQuestion:(NSString *)questionId;

@end

@interface SSQuestionCellView : RMSwipeTableViewCell

@property (weak, nonatomic) id delegate;

@property (copy, nonatomic) NSString *questionId;
@property (assign, nonatomic) NSUInteger voteStatus;
@property (strong, nonatomic) UIButton *voteUpButton;
@property (strong, nonatomic) UIButton *voteDownButton;
@property (strong, nonatomic) UILabel *voteNumLabel;
@property (strong, nonatomic) UILabel *questionLabel;

- (void)setVoteNum:(NSUInteger)voteNum;

@end
