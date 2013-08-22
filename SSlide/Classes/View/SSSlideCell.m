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
        
        float topMargin = 0.f;
        float height = cellHeight - 2*topMargin;
        float width = height;
        float leftMargin = 30.f;
        self.thumbnail = [[UIImageView alloc] initWithFrame:CGRectMake(leftMargin, topMargin, width, height)];
        self.thumbnail.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.thumbnail];
        
        leftMargin += height + 30.f;
        width = cellWidth = leftMargin;
        
        self.title = [[UILabel alloc] initWithFrame:CGRectMake(leftMargin, 20.0f, width, 20.0f)];
        [self addSubview:self.title];
        self.title.backgroundColor = [UIColor clearColor];
        self.title.numberOfLines = 0;
        self.title.adjustsFontSizeToFitWidth = NO;
        self.title.font = [UIFont systemFontOfSize:20];
        
        self.date = [[UILabel alloc] initWithFrame:CGRectMake(leftMargin, 50.0f, width, 20.0f)];
        [self addSubview:self.date];
        self.date.backgroundColor = [UIColor clearColor];
        self.date.font = [UIFont systemFontOfSize:14];
        
        self.author = [[UILabel alloc] initWithFrame:CGRectMake(leftMargin, 80.0f, width, 20.0f)];
        [self addSubview:self.author];
        self.author.backgroundColor = [UIColor clearColor];
        self.author.font = [UIFont systemFontOfSize:14];
        
        self.contentView.backgroundColor = [UIColor clearColor];
    }
    return self;
}

#pragma mark - setData
- (void)setData:(SSSlideshow *)data
{
    [self getThumbnail:[NSURL URLWithString:data.thumbnailUrl]];
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
