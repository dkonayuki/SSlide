//
//  SSTag.m
//  SSlide
//
//  Created by techcamp on 2013/08/26.
//  Copyright (c) 2013年 S2. All rights reserved.
//

#import "SSTag.h"

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
    float height = 30.f;
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
    return self;
}

- (void)deleteTag
{
    
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
