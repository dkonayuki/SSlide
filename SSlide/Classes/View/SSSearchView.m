//
//  SSSearchView.m
//  SSlide
//
//  Created by iNghia on 8/21/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import "SSSearchView.h"
#import <QuartzCore/QuartzCore.h>
#import "SSSlideCell.h"

@interface SSSearchView() <UITextFieldDelegate>

@property (nonatomic) float topMargin;
@property (nonatomic) BOOL didMove;

@end

@implementation SSSearchView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)initView
{
    self.topMargin = [[SSDB5 theme] floatForKey:@"page_top_margin"];
    if (IS_IPAD) {
        self.topMargin *= 2.2;
    }
    float height = [[SSDB5 theme] floatForKey:@"search_textfield_height"];
    float fontSize = 14;
    if (IS_IPAD)
    {
        height *= 2.2;
        fontSize *= 2.2;
    }
    self.backgroundColor = [[SSDB5 theme] colorForKey:@"search_view_bg_color"];
    self.searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width * 0.8f, height)];
    self.searchTextField.center = CGPointMake(self.center.x, self.bounds.size.height/3);
    self.searchTextField.backgroundColor = [UIColor whiteColor];
    self.searchTextField.delegate = self;
    self.searchTextField.font = [UIFont systemFontOfSize:fontSize];
    self.searchTextField.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.searchTextField];
    self.didMove = FALSE;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.delegate searchText:textField.text firstTime:TRUE];
    [textField resignFirstResponder];
    return YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (IS_IPAD)
    {
        return [[SSDB5 theme] floatForKey:@"slide_cell_height_ipad"];
    }
    return [[SSDB5 theme] floatForKey:@"slide_cell_height_iphone"];
}

- (void) initSlideListView
{
    if (!self.slideListView)
    {
        self.slideListView = [[SSSlideListView alloc] initWithFrame:CGRectMake(0,
                                                                        self.topMargin,
                                                                        self.bounds.size.width,
                                                                        self.bounds.size.height - self.topMargin)];
        self.slideListView.delegate = self.delegate;
        [self addSubview:self.slideListView];
    }
}

- (void)moveToTop
{
    if (!self.didMove)
    {
        float topMargin = 10.f;
        if (IS_IPAD)
        {
            topMargin *= 2.2;
        }
        self.didMove = TRUE;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        self.searchTextField.center = CGPointMake(self.bounds.size.width/2, topMargin + [[SSDB5 theme] floatForKey:@"search_textfield_height"]/2);
        [UIView commitAnimations];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
