//
//  SSTagsListView.m
//  SSlide
//
//  Created by iNghia on 8/28/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import "SSTagsListView.h"
#import "SSAddTagView.h"

@interface SSTagsListView() <SSTagViewDelegate, SSAddTagViewDelegate>

@property (strong, nonatomic) NSMutableArray *tagViews;
@property (strong, nonatomic) NSMutableArray *tagStrings;
@property (strong, nonatomic) SSAddTagView *addTagView;

@end

@implementation SSTagsListView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andDelegate:(id)delegate andTagStrings:(NSMutableArray *)tagStrings
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.delegate = delegate;
        self.tagStrings = [[NSMutableArray alloc] initWithArray:tagStrings];
        [self initView];
    }
    return self;
}

- (void)initView
{
    self.tagViews = [[NSMutableArray alloc] init];
    for (NSString *text in self.tagStrings) {
        [self createNewTag:text];
    }
    
    // addtag
    float fontSize = IS_IPAD ? [[SSDB5 theme] floatForKey:@"tag_font_size_ipad"] : [[SSDB5 theme] floatForKey:@"tag_font_size_iphone"];
    self.addTagView = [[SSAddTagView alloc] initWithFrame:CGRectMake(0, 0, 100, 50)
                                              andDelegate:self
                                                 fontSize:fontSize];
    [self addSubview:self.addTagView];
    [self.addTagView refresh];

    [self redraw];
}

- (void)redraw
{
    float height = self.addTagView.frame.size.height;
    float margin = IS_IPAD ? [[SSDB5 theme] floatForKey:@"tag_margin_ipad"] : [[SSDB5 theme] floatForKey:@"tag_margin_iphone"];
    float x = margin;
    int row = 0;
    for (SSTagView *tagView in self.tagViews) {
        if(x + tagView.frame.size.width + margin > self.bounds.size.width) {
            row += 1;
            x = margin;
        }
        CGRect curRect = tagView.frame;
        curRect.origin.x = x;
        curRect.origin.y = row*(height + margin) + margin;
        tagView.frame = curRect;
        
        x += tagView.bounds.size.width + margin;
    }
    // draw addTag
    if(x + self.addTagView.frame.size.width + margin > self.bounds.size.width) {
        row += 1;
        x = margin;
    }
    CGRect curRect = self.addTagView.frame;
    curRect.origin.x = x;
    curRect.origin.y = row*(height + margin) + margin;
    self.addTagView.frame = curRect;
    
    x += self.addTagView.bounds.size.width + margin;
}

#pragma mark - SSTagViewDelegate
- (void)redrawDel
{
    [self redraw];
}

- (void)removeTagDel:(SSTagView *)tagView
{
    [self.delegate didRemoveTag:tagView.text];
    [self.tagStrings removeObject:[NSString stringWithString:tagView.text]];
    [self.tagViews removeObject:tagView];
    [tagView removeFromSuperview];
    [self redraw];
}

- (void)addTagDel:(NSString *)tagText
{
    [self.delegate didAddTag:tagText];
    [self createNewTag:tagText];
    [self redraw];
}

#pragma mark - private
- (void)createNewTag:(NSString *)text
{
    float fontSize = IS_IPAD ? [[SSDB5 theme] floatForKey:@"tag_font_size_ipad"] : [[SSDB5 theme] floatForKey:@"tag_font_size_iphone"];
    SSTagView *newTag = [[SSTagView alloc] initWithFrame:CGRectMake(0, 0, 100, 50)
                                             andDelegate:self
                                                    text:text
                                                fontSize:fontSize];
    [self addSubview:newTag];
    [self.tagViews addObject:newTag];
    [newTag refresh];
}

@end
