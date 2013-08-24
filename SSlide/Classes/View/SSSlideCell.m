//
//  SSSlideCell.m
//  SSlide
//
//  Created by iNghia on 8/22/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import "SSSlideCell.h"
#import "SSDB5.h"
#import "SSSlideshow.h"
#import <AFNetworking/AFImageRequestOperation.h>

@interface SSSlideCell()

@property (strong, nonatomic) UIImageView *thumbnail;
@property (strong, nonatomic) UILabel *title;
@property (strong, nonatomic) UILabel *date;
@property (strong, nonatomic) UILabel *author;

@end

@implementation SSSlideCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
        
        float cellHeight = IS_IPAD ? [[SSDB5 theme] floatForKey:@"slide_cell_height_ipad"] : [[SSDB5 theme] floatForKey:@"slide_cell_height_iphone"];
        float cellWidth = IS_IPAD ? 680.f : 320.f;
        float titleFontSize;
        float detailsFontSize;
        float topMargin = 5.f;
        float height = cellHeight - 2*topMargin - 20.f;
        float width = 100.f;
        float leftMargin = 10.f;
        if (IS_IPAD)
        {
            leftMargin = leftMargin * 2.2;
            topMargin *= 2.2;
            width *= 2.2;
        }
        self.thumbnail = [[UIImageView alloc] initWithFrame:CGRectMake(leftMargin, topMargin, width, height)];
        self.thumbnail.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:self.thumbnail];
        
        leftMargin = leftMargin * 2 + width;
        width = cellWidth - leftMargin;
        topMargin = 5.f;
        height = 20.f;
        titleFontSize = 14.f;
        detailsFontSize = 12.f;
        if (IS_IPAD)
        {
            topMargin = topMargin * 2.2;
            height = height * 2.2;
            titleFontSize = titleFontSize * 1.5;
            detailsFontSize = detailsFontSize * 1.5;
        }
        
        self.title = [[UILabel alloc] initWithFrame:CGRectMake(leftMargin, topMargin, width, height)];
        [self addSubview:self.title];
        self.title.backgroundColor = [UIColor clearColor];
        self.title.numberOfLines = 2;
        //self.title.adjustsFontSizeToFitWidth = NO;
        self.title.font = [UIFont systemFontOfSize:titleFontSize];
        self.title.lineBreakMode = NSLineBreakByWordWrapping;
        
        topMargin += 40.f;
        if (IS_IPAD)
        {
            topMargin += 50.f;
        }
        self.date = [[UILabel alloc] initWithFrame:CGRectMake(leftMargin, topMargin, width, height)];
        [self addSubview:self.date];
        self.date.backgroundColor = [UIColor clearColor];
        self.date.font = [UIFont systemFontOfSize:detailsFontSize];
        
        topMargin += 20.f;
        if (IS_IPAD)
        {
            topMargin += 30.f;
        }
        self.author = [[UILabel alloc] initWithFrame:CGRectMake(leftMargin, topMargin, width, height)];
        [self addSubview:self.author];
        self.author.backgroundColor = [UIColor clearColor];
        self.author.font = [UIFont systemFontOfSize:detailsFontSize];
        
        self.contentView.backgroundColor = [UIColor clearColor];
    }
    return self;
}

#pragma mark - setData
- (void)setData:(SSSlideshow *)data
{
    [self getThumbnail:[NSURL URLWithString:data.thumbnailUrl]];
    CGSize size = [data.title sizeWithFont:self.title.font
                         constrainedToSize:CGSizeMake(self.title.bounds.size.width,
                                                      2 * self.title.font.lineHeight)
                             lineBreakMode:self.title.lineBreakMode];
    CGRect newFrame = self.title.frame;
    newFrame.size.height = size.height;
    self.title.frame = newFrame;
    self.title.text = data.title;
    self.date.text = data.created;
    self.author.text = data.username;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)getThumbnail:(NSURL *)url{
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFImageRequestOperation *operation = [AFImageRequestOperation imageRequestOperationWithRequest:request success:^(UIImage *image) {
        self.thumbnail.image = image;
    }];
                                          
    [operation start];
}

@end
