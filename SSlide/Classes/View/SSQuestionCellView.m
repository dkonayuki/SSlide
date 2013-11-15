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
        float topMargin = 10.0;
        float rightMargin = 30.f;
        float btnWith = 40.f;
        
        // vote up
        self.voteUpButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.contentView.frame) - rightMargin,
                                                                       topMargin,
                                                                       btnWith,
                                                                       btnWith)];
        [self.voteUpButton addTarget:self action:@selector(voteUpBtnPressed:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:self.voteUpButton];
        
        // vote down
        self.voteDownButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.contentView.frame) - rightMargin,
                                                                         2*topMargin + btnWith,
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
}

- (void)voteDownBtnPressed:(UIButton *)sender
{
    if (self.voteStatus != VOTE_NONE) {
        return;
    }
    
    [self.delegate voteDownQuestion:self.questionId];
    [self.voteDownButton setBackgroundImage:[UIImage imageNamed:@"vote_up_enable"] forState:UIControlStateNormal];
    self.voteStatus = VOTE_DOWN;
}

@end
