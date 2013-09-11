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
#import "SSSearchOptionView.h"

@interface SSSearchView() <UITextFieldDelegate, SSSearchOptionViewDelegate>

@property (assign, nonatomic) float topMargin;
@property (assign, nonatomic) BOOL didMove;
@property (strong, nonatomic) UIView *searchBG;
@property (strong, nonatomic) SSSearchOptionView *searchOptionView;
@property (assign, nonatomic) NSUInteger searchOption;

@end

@implementation SSSearchView

- (void)initView
{
    self.topMargin = IS_IPAD ? [[SSDB5 theme]floatForKey:@"page_top_margin_ipad"] : [[SSDB5 theme]floatForKey:@"page_top_margin_iphone"];
    
    float height = [[SSDB5 theme] floatForKey:@"search_textfield_height"];
    float fontSize = 14;
    if (IS_IPAD) {
        height *= 2.2;
        fontSize *= 2.2;
    }
    UIColor *bgColor = SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0") ? [UIColor clearColor] : [[SSDB5 theme] colorForKey:@"app_title_color"];
    self.searchBG = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.topMargin)];
    self.searchBG.backgroundColor = bgColor;
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
    [layer setCornerRadius: IS_IPAD ? 4.f : 2.f];
    
    float bttWidth = 15.f;
    float bttHeight = 15.f;
    float margin = 10.f;
    width = width - bttWidth * 2 - margin;
    if (IS_IPAD) {
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
    if (IS_IPAD) {
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
    
    // search optionView
    float sH = IS_IPAD ? [[SSDB5 theme] floatForKey:@"search_option_view_height_ipad"] : [[SSDB5 theme] floatForKey:@"search_option_view_height_iphone"];
    self.searchOptionView = [[SSSearchOptionView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, sH) andDelegate:self];
    [self addSubview:self.searchOptionView];
    float xCenter = self.bounds.size.width/2;
    float yCenter = self.bounds.size.height + sH;
    self.searchOptionView.center = CGPointMake(xCenter, yCenter);
    self.searchOptionView.hidden = YES;
    self.searchOption = SEARCH_OPTION_RELEVANCE;
}

- (void)deleteText
{
    self.searchTextField.text = @"";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (IS_IPAD) {
        return [[SSDB5 theme] floatForKey:@"slide_cell_height_ipad"];
    }
    return [[SSDB5 theme] floatForKey:@"slide_cell_height_iphone"];
}

- (void) initSlideListView
{
    if (!self.slideListView) {
        float statusBarHeight = SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0") ? 20.f : 0.f;
        self.slideListView = [[SSSlideListView alloc] initWithFrame:CGRectMake(0,
                                                                               self.topMargin + statusBarHeight,
                                                                               self.bounds.size.width,
                                                                               self.bounds.size.height - self.topMargin)
                                                        andDelegate:self.delegate];
        [self addSubview:self.slideListView];
    }
}

- (void)moveToTop
{
    if (!self.didMove) {
        float statusBarHeight = SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0") ? 20.f : 0.f;
        self.didMove = TRUE;
        [UIView animateWithDuration:0.5f animations:^(void) {
            self.searchBG.center = CGPointMake(self.bounds.size.width/2,
                                               statusBarHeight + self.topMargin/2);
        }];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (self.searchTextField.text && ![self.searchTextField.text isEqualToString:@""]) {
        [self.delegate searchText:textField.text option:self.searchOption firstTime:TRUE completion:^(void){}];
        [textField resignFirstResponder];
    }
    return YES;
}

#pragma mark - SSSearchOptionView delegate
- (void)searchOptionSeletedDel:(NSUInteger)index
{
    self.searchOption = index;
}

#pragma mark - keyboard event
- (void) keyboardWillShow:(NSNotification *)note {
    NSDictionary *userInfo = [note userInfo];
    CGRect kbRect = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    float xCenter = self.bounds.size.width/2;
    float yCenter = self.bounds.size.height - kbRect.size.height - self.searchOptionView.frame.size.height/2;
    self.searchOptionView.hidden = NO;
    [self bringSubviewToFront:self.searchOptionView];
    
    [UIView animateWithDuration:0.25f
                     animations:^{
                         self.searchOptionView.center = CGPointMake(xCenter, yCenter);
                     }];
}

- (void) keyboardWillHide:(NSNotification *)note {
    float xCenter = self.bounds.size.width/2;
    float yCenter = self.bounds.size.height + self.searchOptionView.frame.size.height;

    [UIView animateWithDuration:0.25f
                     animations:^{
                         self.searchOptionView.center = CGPointMake(xCenter, yCenter);
                     }
                     completion:^(BOOL finish){
                         self.searchOptionView.hidden = YES;
                     }];
}

@end
