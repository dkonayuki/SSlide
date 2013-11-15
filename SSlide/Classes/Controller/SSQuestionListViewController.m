//
//  SSQuestionListViewController.m
//  SSlide
//
//  Created by iNghia on 10/15/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import "SSQuestionListViewController.h"
#import "SSQuestion.h"
#import "SSQuestionCellView.h"
#import <AFNetworking/AFHTTPClient.h>
#import <AFJSONRequestOperation.h>
#import "SSAppData.h"

@interface SSQuestionListViewController () <UITableViewDelegate, UITableViewDataSource, SSQuestionCellViewDelegate>

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
    SSQuestionCellView *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[SSQuestionCellView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.delegate = self;
    cell.textLabel.numberOfLines = 0;
    SSQuestion *curQues = [self.questions objectAtIndex:indexPath.row];
    cell.textLabel.text = curQues.content;
    cell.questionId = curQues.questionId;
    cell.voteStatus = curQues.voteStatus;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SSQuestion *curQues = [self.questions objectAtIndex:indexPath.row];
    [self.delegate didSelectQuestionAtPage:curQues.pageNum];
}

#pragma mark - delegate
/*
-(void)swipeTableViewCellWillResetState:(RMSwipeTableViewCell *)swipeTableViewCell fromPoint:(CGPoint)point animation:(RMSwipeTableViewCellAnimationType)animation velocity:(CGPoint)velocity {
    
    if ( point.x >= CGRectGetHeight(swipeTableViewCell.frame) / 2 ) {
        NSLog(@"VOTE DOWN");
        NSIndexPath *indexPath = [self.tableView indexPathForCell:swipeTableViewCell];
        SSQuestion *curQues = [self.questions objectAtIndex:indexPath.row];
        [self voteQuestion:curQues.questionId type:@"down"];
        
    } else if ( point.x < 0 && -point.x >= CGRectGetHeight(swipeTableViewCell.frame) / 2 ) {
        NSLog(@"VOTE UP");
        NSIndexPath *indexPath = [self.tableView indexPathForCell:swipeTableViewCell];
        SSQuestion *curQues = [self.questions objectAtIndex:indexPath.row];
        [self voteQuestion:curQues.questionId type:@"up"];
    }
}
 */

- (void)voteUpQuestion:(NSString *)questionId
{
    [self voteQuestion:questionId type:@"up"];
}

- (void)voteDownQuestion:(NSString *)questionId
{
    [self voteQuestion:questionId type:@"down"];
}

- (void)voteQuestion:(NSString *)questionId type:(NSString *)type
{
    // post to server
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[[SSDB5 theme] stringForKey:@"SS_SERVER_BASE_URL"]]];
    [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [client setDefaultHeader:@"Accept" value:@"application/json"];
    
    NSString *curUsername = [SSAppData sharedInstance].currentUser.username;

    NSString *url = [NSString stringWithFormat:@"/question/vote"];
    NSDictionary *params = @{@"question_id": questionId,
                             @"type": type,
                             @"user_name": curUsername};
    
    [client postPath:url
          parameters:params
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 NSLog(@"Vote Question OK");
             }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 NSLog(@"error: %@", error);
                 [SVProgressHUD showErrorWithStatus:@"Error!"];
             }];
    
}

@end
