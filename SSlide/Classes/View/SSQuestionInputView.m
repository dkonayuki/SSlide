//
//  SSQuestionInputView.m
//  SSlide
//
//  Created by iNghia on 10/14/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import "SSQuestionInputView.h"

@interface SSQuestionInputView()

@property (strong, nonatomic) UITextView *questionInputTextView;

@end

@implementation SSQuestionInputView

- (void)initView
{
    float h = self.bounds.size.height;
    float btn_margin = 0;
    
    float font_size = IS_IPAD ? 30.f : 20.f;
    float btnh = (h - 4*btn_margin)/2;
    float btnw = IS_IPAD ? 1.2*btnh : btnh;
    float w = self.bounds.size.width - btnw - btn_margin;
 
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 5.f;
    self.layer.borderWidth = 2.f;
    self.layer.borderColor = [[SSDB5 theme] colorForKey:@"question_input_border_color"].CGColor;
    
    self.questionInputTextView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, w, h)];
    self.questionInputTextView.layer.cornerRadius = 5.f;
    self.questionInputTextView.font = [UIFont systemFontOfSize:font_size];
    [self addSubview:self.questionInputTextView];
    
    UIButton *sendButton = [[UIButton alloc] initWithFrame:CGRectMake(w - btn_margin, btn_margin, btnw, btnh)];
    sendButton.backgroundColor = [UIColor whiteColor];
    [sendButton setTitle:@"Send" forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(sendQuestionButtonPressed) forControlEvents:UIControlEventTouchDown];
    [self addSubview:sendButton];
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(w - btn_margin, h/2 + btn_margin, btnw, btnh)];
    cancelButton.backgroundColor = [UIColor whiteColor];
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelQuestionButtonPressed) forControlEvents:UIControlEventTouchDown];
    [self addSubview:cancelButton];
    
    self.hidden = YES;
}

- (void)show
{
    self.hidden = NO;
    [self.questionInputTextView becomeFirstResponder];
}

- (void)hide
{
    self.hidden = YES;
    [self.questionInputTextView resignFirstResponder];
}

- (void)sendQuestionButtonPressed
{
    [self.delegate sendQuestion:[self.questionInputTextView text]];
    [self.questionInputTextView setText:@""];
    [self cancelQuestionButtonPressed];
}

- (void)cancelQuestionButtonPressed
{
    self.hidden = YES;
    [self.questionInputTextView resignFirstResponder];
    [self.delegate cancelQuestion];
}

@end
