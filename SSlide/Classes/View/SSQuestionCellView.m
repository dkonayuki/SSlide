//
//  SSQuestionCellView.m
//  SSlide
//
//  Created by Le Van Nghia on 11/15/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import "SSQuestionCellView.h"
#import "SSQuestion.h"

@implementation SSQuestionCellView

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        float topMargin = 4.0;
        float labelHeight = 18.f;
        float rightMargin = 30.f;
        float btnWith = 40.f;
        float cellHeight = 100.f;
        
        self.questionLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.contentView.frame) + topMargin,
                                                                      CGRectGetMinY(self.contentView.frame) + topMargin,
                                                                      CGRectGetWidth(self.contentView.frame) - btnWith,
                                                                      cellHeight - 2*topMargin)];
        self.questionLabel.numberOfLines = 0;
        [self addSubview:self.questionLabel];
        
        // vote up
        self.voteUpButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.contentView.frame) - rightMargin,
                                                                       topMargin,
                                                                       btnWith,
                                                                       btnWith)];
        [self.voteUpButton addTarget:self action:@selector(voteUpBtnPressed:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:self.voteUpButton];
        
        // vote num lable
        self.voteNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.contentView.frame) - rightMargin,
                                                                     topMargin + btnWith,
                                                                     btnWith,
                                                                     labelHeight)];
        self.voteNumLabel.font = [UIFont systemFontOfSize:20.f];
        self.voteNumLabel.textColor = [UIColor grayColor];
        [self.voteNumLabel setTextAlignment:NSTextAlignmentCenter];
        [self.voteNumLabel setText:@"0"];
        [self addSubview:self.voteNumLabel];
        
        // vote down
        self.voteDownButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.contentView.frame) - rightMargin,
                                                                         topMargin + btnWith + labelHeight,
                                                                         btnWith,
                                                                         btnWith)];
        [self.voteDownButton addTarget:self action:@selector(voteDownBtnPressed:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:self.voteDownButton];
    }
    return self;
}

- (void)setVoteStatus:(NSUInteger)voteStatus
{
    _voteStatus = voteStatus;
    
    switch (voteStatus) {
        case VOTE_UP:
            [self.voteUpButton setBackgroundImage:[UIImage imageNamed:@"vote_up_enable"] forState:UIControlStateNormal];
            [self.voteDownButton setBackgroundImage:[UIImage imageNamed:@"vote_down_disable"] forState:UIControlStateNormal];
            break;
            
        case VOTE_DOWN:
            [self.voteUpButton setBackgroundImage:[UIImage imageNamed:@"vote_up_disable"] forState:UIControlStateNormal];
            [self.voteDownButton setBackgroundImage:[UIImage imageNamed:@"vote_down_enable"] forState:UIControlStateNormal];
            break;
            
        case VOTE_NONE:
            [self.voteUpButton setBackgroundImage:[UIImage imageNamed:@"vote_up_disable"] forState:UIControlStateNormal];
            [self.voteDownButton setBackgroundImage:[UIImage imageNamed:@"vote_down_disable"] forState:UIControlStateNormal];
            break;
            
        default:
            break;
    }
}

- (void)voteUpBtnPressed:(UIButton *)sender
{
    if (self.voteStatus != VOTE_NONE) {
        return;
    }
    
    [self.delegate voteUpQuestion:self.questionId];
    [self.voteUpButton setBackgroundImage:[UIImage imageNamed:@"vote_up_enable"] forState:UIControlStateNormal];
    self.voteStatus = VOTE_UP;
    
    NSUInteger voteNum = [self.voteNumLabel.text integerValue] + 1;
    [self setVoteNum:voteNum];
}

- (void)voteDownBtnPressed:(UIButton *)sender
{
    if (self.voteStatus != VOTE_NONE) {
        return;
    }
    
    [self.delegate voteDownQuestion:self.questionId];
    [self.voteDownButton setBackgroundImage:[UIImage imageNamed:@"vote_up_enable"] forState:UIControlStateNormal];
    self.voteStatus = VOTE_DOWN;
    
    NSUInteger voteNum = [self.voteNumLabel.text integerValue] - 1;
    [self setVoteNum:voteNum];
}

- (void)setVoteNum:(NSUInteger)voteNum
{
    [self.voteNumLabel setText:[NSString stringWithFormat:@"%d", voteNum]];
}

@end
