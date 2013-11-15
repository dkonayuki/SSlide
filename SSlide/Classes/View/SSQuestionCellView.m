//
//  SSQuestionCellView.m
//  SSlide
//
//  Created by Le Van Nghia on 11/15/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import "SSQuestionCellView.h"

@implementation SSQuestionCellView

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier];
    if (self) {
        //self.textLabel.font = [UIFont fontWithName:@"Avenir-Heavy" size:16];
        //self.textLabel.backgroundColor = self.contentView.backgroundColor;
        //self.detailTextLabel.font = [UIFont fontWithName:@"Avenir-Book" size:14];
        //self.detailTextLabel.backgroundColor = self.contentView.backgroundColor;
        
        float topMargin = 30.0;
        
        // vote up
        self.voteUpImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.contentView.frame),
                                                                             topMargin,
                                                                             CGRectGetHeight(self.frame),
                                                                             CGRectGetHeight(self.frame))];
        [self.voteUpImageView setImage:[UIImage imageNamed:@"vote_up_enable"]];
        [self.voteUpImageView setContentMode:UIViewContentModeCenter];
        [self.backView addSubview:self.voteUpImageView];
        
        // vote down
        self.voteDownImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                               topMargin,
                                                                               CGRectGetHeight(self.frame),
                                                                               CGRectGetHeight(self.frame))];
        [self.voteDownImageView setImage:[UIImage imageNamed:@"vote_down_enable"]];
        [self.voteDownImageView setContentMode:UIViewContentModeCenter];
        [self.backView addSubview:self.voteDownImageView];
    }
    return self;
}

@end
