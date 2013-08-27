//
//  SSTag.m
//  SSlide
//
//  Created by techcamp on 2013/08/26.
//  Copyright (c) 2013年 S2. All rights reserved.
//

#import "SSTag.h"
#import <QuartzCore/QuartzCore.h>

@implementation SSTag

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andName:(NSString *)tag
{
    self = [super initWithFrame:frame];
    float topMargin = 0;
    float leftMargin = 0;
    float width = 100.f;
    float height = 50.f;
    if (self)
    {
        //tag label
        width =  [tag sizeWithFont:[UIFont systemFontOfSize:20 ]].width;
        UILabel *tagLabel = [[UILabel alloc]initWithFrame:CGRectMake(leftMargin, topMargin, width, height)];
        tagLabel.text = tag;
        [self addSubview:tagLabel];
        
        //delete tag button
        UIButton *deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(width, topMargin, 30.f, height)];
        [deleteButton setTitle:@"x" forState:UIControlStateNormal];
        deleteButton.backgroundColor = [UIColor colorFromHexCode:@"777777"];
        [deleteButton addTarget:deleteButton action:@selector(deleteTag) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:deleteButton];
    }
    CGRect myFrame = self.frame;
    myFrame.size.width = width + 30.f;
    self.frame = myFrame;
    self.layer.borderColor = [[SSDB5 theme] colorForKey:@"tag_bg_color"].CGColor;
    self.layer.borderWidth = 1.f;
    return self;
}

- (void)deleteTag
{
    
}

@end
