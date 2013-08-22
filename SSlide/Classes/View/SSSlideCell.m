//
//  SSSlideCell.m
//  SSlide
//
//  Created by iNghia on 8/22/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import "SSSlideCell.h"
#import "SSDB5.h"

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

- (void)setDataWithDictionary:(NSDictionary *)data
{
    self.thumbnail = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[data objectForKey:@"thumbnail"]]];
    self.thumbnail.frame = CGRectMake(10.0f, 10.0f, 100.0f, 100.0f);
    self.title.text = [data objectForKey:@"title"];
    self.date.text = [data objectForKey:@"date"];
    self.author.text = [data objectForKey:@"author"];
}

- (id)init {
    self = [super init];
    if (self) {
        self.thumbnail = [[UIImageView alloc] init];
        self.title = [[UILabel alloc] initWithFrame:CGRectMake(100.0f, 20.0f, 100.0f, 20.0f)];
        self.date = [[UILabel alloc] initWithFrame:CGRectMake(100.0f, 50.0f, 100.0f, 20.0f)];
        self.author = [[UILabel alloc] initWithFrame:CGRectMake(100.0f, 80.0f, 100.0f, 20.0f)];
        [self addSubview:self.thumbnail];
        [self addSubview:self.title];
        [self addSubview:self.date];
        [self addSubview:self.author];
        self.contentView.backgroundColor = [UIColor clearColor];
    }
    return self;
}

@end
