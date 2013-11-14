//
//  SSQuestionListViewController.m
//  SSlide
//
//  Created by iNghia on 10/15/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import "SSQuestionListViewController.h"
#import "SSQuestion.h"
#import <RMSwipeTableViewCell/RMSwipeTableViewCell.h>

@interface SSQuestionListViewController () <UITableViewDelegate, UITableViewDataSource, RMSwipeTableViewCellDelegate>

@property (strong, nonatomic) NSArray *questions;

@end

@implementation SSQuestionListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

- (void)setQuestionList:(NSArray *)questions
{
    self.questions = questions;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.questions count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"QuestionCell";
    RMSwipeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[RMSwipeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.delegate = self;
    cell.textLabel.numberOfLines = 0;
    SSQuestion *curQues = [self.questions objectAtIndex:indexPath.row];
    cell.textLabel.text = curQues.content;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SSQuestion *curQues = [self.questions objectAtIndex:indexPath.row];
    [self.delegate didSelectQuestionAtPage:curQues.pageNum];
}

#pragma mark - delegate
-(void)swipeTableViewCellWillResetState:(RMSwipeTableViewCell *)swipeTableViewCell fromPoint:(CGPoint)point animation:(RMSwipeTableViewCellAnimationType)animation velocity:(CGPoint)velocity {
    
    if ( point.x >= CGRectGetHeight(swipeTableViewCell.frame) / 2 ) {
        //NSIndexPath *indexPath = [self.tableView indexPathForCell:swipeTableViewCell];
        NSLog(@"VOTE DOWN");
        
    } else if ( point.x < 0 && -point.x >= CGRectGetHeight(swipeTableViewCell.frame) / 2 ) {
        NSLog(@"VOTE UP");
        
    }
}

@end
