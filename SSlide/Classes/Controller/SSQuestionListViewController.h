//
//  SSQuestionListViewController.h
//  SSlide
//
//  Created by iNghia on 10/15/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import "SSViewController.h"

@interface SSQuestionListViewController : SSViewController

@property (strong, nonatomic) UITableView *tableView;

- (void)setQuestionList:(NSArray *)questions;

@end
