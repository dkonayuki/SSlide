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

@property (nonatomic, strong) UIImageView *thumbnail;
@property (nonatomic, strong) UILabel *title, *date, *author;

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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(SSSlideshow *)data
{
    [self getThumbnail:[NSURL URLWithString:data.ThumbnailURL]];
    self.thumbnail.frame = CGRectMake(10.0f, 10.0f, 100.0f, 100.0f);
    self.title.text = data.Title;
    self.date.text = data.Created;
    self.author.text = data.Username;
}

- (void)initThumbnail
{
    self.thumbnail = [[UIImageView alloc] init];
    [self addSubview:self.thumbnail];
    self.thumbnail.backgroundColor = [UIColor clearColor];
}

- (void)initTitle
{
    self.title = [[UILabel alloc] initWithFrame:CGRectMake(120.0f, 20.0f, 180.0f, 20.0f)];
    [self addSubview:self.title];
    self.title.backgroundColor = [UIColor clearColor];
    self.title.numberOfLines = 0;
    self.title.adjustsFontSizeToFitWidth = NO;
    self.title.font = [UIFont systemFontOfSize:20];
}

- (void)initDate
{
    self.date = [[UILabel alloc] initWithFrame:CGRectMake(120.0f, 50.0f, 180.0f, 20.0f)];
    [self addSubview:self.date];
    self.date.backgroundColor = [UIColor clearColor];
    self.date.font = [UIFont systemFontOfSize:14];
}

- (void)initAuthor
{
    self.author = [[UILabel alloc] initWithFrame:CGRectMake(120.0f, 80.0f, 180.0f, 20.0f)];
    [self addSubview:self.author];
    self.author.backgroundColor = [UIColor clearColor];
    self.author.font = [UIFont systemFontOfSize:14];
}

- (id)init {
    self = [super init];
    if (self) {
        [self initThumbnail];
        [self initTitle];
        [self initDate];
        [self initAuthor];
        self.contentView.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)getThumbnail:(NSURL *)url{
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    AFImageRequestOperation *operation = [AFImageRequestOperation imageRequestOperationWithRequest:request success:^(UIImage *image) {
        self.thumbnail.image = image;
    }];
                                          
    [operation start];
}

@end
