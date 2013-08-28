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
@property (strong, nonatomic) UIView *searchBG;

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
    self.topMargin = IS_IPAD ? [[SSDB5 theme]floatForKey:@"page_top_margin_ipad"] : [[SSDB5 theme]floatForKey:@"page_top_margin_iphone"];
    
    float height = [[SSDB5 theme] floatForKey:@"search_textfield_height"];
    float fontSize = 14;
    if (IS_IPAD)
    {
        height *= 2.2;
        fontSize *= 2.2;
    }
    self.searchBG = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.topMargin)];
    self.searchBG.backgroundColor =  [[SSDB5 theme] colorForKey:@"app_title_color"];
    self.searchBG.center = CGPointMake(self.center.x, self.bounds.size.height/3);
    [self addSubview:self.searchBG];
    
    float width = self.bounds.size.width * 0.8f;
    
    //text background
    UIView *textBG;
    textBG = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width * 0.8f, height)];
    textBG.backgroundColor = [[SSDB5 theme] colorForKey:@"searchbar_bg_color"];
    textBG.center = CGPointMake(self.searchBG.center.x, self.searchBG.frame.size.height/2);
    [self.searchBG addSubview:textBG];
    CALayer *layer = [textBG layer];
    [layer setMasksToBounds:YES];
    if (IS_IPAD)
    {
        [layer setCornerRadius:4.0];
    } else
    {
        [layer setCornerRadius:2.0];
    }
    
    float bttWidth = 15.f;
    float bttHeight = 15.f;
    float margin = 10.f;
    width = width - bttWidth * 2 - margin;
    if (IS_IPAD)
    {
        bttWidth *= 2.2;
        bttHeight *= 2.2;
        width = width - bttWidth * 2 - margin * 2.2;
    }
    
    //search button
    UIButton *search = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, bttWidth, bttHeight)];
    UIImage *searchImg = [UIImage imageNamed:@"search.png"];
    [search setImage:searchImg forState:UIControlStateNormal];
    [search setImage:searchImg forState:UIControlStateSelected];
    [search addTarget:self action:@selector(searchText) forControlEvents:UIControlEventTouchDown];
    search.center = CGPointMake(self.searchBG.center.x - (bttWidth + width)/2, self.searchBG.frame.size.height/2);
    [self.searchBG addSubview:search];
    
    bttWidth /= 1.3;
    bttHeight /= 1.3;
    //delete button
    UIButton *delete = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, bttWidth, bttHeight)];
    UIImage *deleteImg = [UIImage imageNamed:@"delete_search.png"];
    [delete setImage:deleteImg forState:UIControlStateNormal];
    [delete setImage:deleteImg forState:UIControlStateSelected];
    [delete addTarget:self action:@selector(deleteText) forControlEvents:UIControlEventTouchDown];
    delete.center = CGPointMake(self.searchBG.center.x + (bttWidth + width)/2, self.searchBG.frame.size.height/2);
    [self.searchBG addSubview:delete];
    
    //search textfield
    margin = 20.f;
    width -= margin;
    height = 15.f;
    if (IS_IPAD)
    {
        width -= margin;
        height *= 2.2f;
    }
    self.searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    self.searchTextField.center = CGPointMake(self.searchBG.center.x, self.searchBG.frame.size.height/2);
    self.searchTextField.backgroundColor = [UIColor whiteColor];
    self.searchTextField.delegate = self;
    self.searchTextField.textColor = [[SSDB5 theme] colorForKey:@"searchbar_text_color"];
    self.searchTextField.placeholder = [[SSDB5 theme] stringForKey:@"searchbar_plate"];
    self.searchTextField.font = [UIFont fontWithName:[[SSDB5 theme] stringForKey:@"quicksand_font"] size:fontSize];
    [self.searchBG addSubview:self.searchTextField];
    self.didMove = FALSE;
}

- (void)searchText
{
    if (self.searchTextField.text && ![self.searchTextField.text isEqualToString:@""])
    {
        [self.delegate searchText:self.searchTextField.text firstTime:TRUE completion:^(void) {}];
        [self endEditing:YES];
    }
}

- (void)deleteText
{
    self.searchTextField.text = @"";
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.searchTextField.text && ![self.searchTextField.text isEqualToString:@""])
    {
        [self.delegate searchText:textField.text firstTime:TRUE completion:^(void){}];
        [textField resignFirstResponder];
    }
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
                                                                               self.bounds.size.height - self.topMargin)
                                                        andDelegate:self.delegate];
        [self addSubview:self.slideListView];
    }
}

- (void)moveToTop
{
    if (!self.didMove)
    {
        self.didMove = TRUE;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        self.searchBG.center = CGPointMake(self.bounds.size.width/2, self.topMargin/2);
        [UIView commitAnimations];
    }
}

@end
