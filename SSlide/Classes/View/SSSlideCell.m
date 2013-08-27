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
#import <QuartzCore/QuartzCore.h>

@interface SSSlideCell()

@property (strong, nonatomic) UIImageView *thumbnail;
@property (strong, nonatomic) UILabel *title;
@property (strong, nonatomic) UILabel *date;
@property (strong, nonatomic) UILabel *author;
@property (strong, nonatomic) UILabel *viewsNumber;
@property (strong, nonatomic) UILabel *likesNumber;
@property (strong, nonatomic) UILabel *downloadsNumber;


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
        float height = cellHeight - 2*topMargin - 2.f;
        float leftMargin = cellWidth / 14;
        float width = cellWidth - 2 * leftMargin;

        if (IS_IPAD)
        {
            topMargin *= 2.2;
            width += 90.f;
        }
        UIImageView *cellBg = [[UIImageView alloc] initWithFrame:CGRectMake(leftMargin, topMargin, width, height)];
        cellBg.backgroundColor = [[SSDB5 theme] colorForKey:@"cell_bg_color"];
        [self addSubview:cellBg];
        CALayer *layer = [cellBg layer];
        [layer setMasksToBounds:YES];
        if (IS_IPAD)
        {
            [layer setCornerRadius:4.0];
        } else
        {
            [layer setCornerRadius:2.0];
        }
        
        leftMargin += 2.f;
        width = 100.f;
        topMargin += 2.f;
        height -= 4.f;
        if (IS_IPAD)
        {
            width *= 2.2;
            leftMargin += 2.f;
            topMargin += 2.f;
            height -= 4.f;
        }
        UIImageView *thumbnailBg = [[UIImageView alloc] initWithFrame:CGRectMake(leftMargin, topMargin, width, height)];
        thumbnailBg.backgroundColor = [[SSDB5 theme] colorForKey:@"thumbnail_bg_color"];
        [self addSubview:thumbnailBg];
        
        leftMargin += 2.f;
        width -= 4.f;
        topMargin += 2.f;
        height -= 4.f;
        if (IS_IPAD)
        {
            leftMargin += 2.f;
            topMargin += 2.f;
            width -= 4.f;
            height -= 4.f;
        }
        self.thumbnail = [[UIImageView alloc] initWithFrame:CGRectMake(leftMargin, topMargin, width, height)];
        self.thumbnail.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:self.thumbnail];
        
        leftMargin = leftMargin + width + 10.f;
        width = cellWidth - leftMargin - 30.f;
        topMargin = 12.f;
        height = 16.f;
        titleFontSize = 14.f;
        detailsFontSize = 9.f;
        if (IS_IPAD)
        {
            topMargin = topMargin * 2.2;
            height = height * 2.2;
            titleFontSize = titleFontSize * 2.4;
            detailsFontSize = detailsFontSize * 2.2;
            leftMargin += 15.f;
            width += 40.f;
        }
        
        self.title = [[UILabel alloc] initWithFrame:CGRectMake(leftMargin, topMargin, width, height * 2)];
        [self addSubview:self.title];
        self.title.backgroundColor = [UIColor clearColor];
        self.title.numberOfLines = 2;
        self.title.font = [UIFont fontWithName:@"NVTBahamasHeavyBold" size:titleFontSize];
        //self.title.adjustsFontSizeToFitWidth = NO;
        self.title.lineBreakMode = NSLineBreakByWordWrapping;
        self.title.textColor = [[SSDB5 theme]colorForKey:@"slide_title_color"];
        
        leftMargin += 5.f;
        width -= 15.f; //for right margin
        topMargin += 35.f;
        if (IS_IPAD)
        {
            leftMargin += 5.f;
            width -= 15.f;
            topMargin += 45.f;
        }
        self.date = [[UILabel alloc] initWithFrame:CGRectMake(leftMargin, topMargin, width/2, height)];
        [self addSubview:self.date];
        self.date.backgroundColor = [UIColor clearColor];
        self.date.font = [UIFont fontWithName:@"Candara" size:detailsFontSize];
        self.date.textColor = [[SSDB5 theme]colorForKey:@"slide_details_color"];
        self.author = [[UILabel alloc] initWithFrame:CGRectMake(leftMargin + width/2, topMargin, width/2, height)];
        [self addSubview:self.author];
        self.author.backgroundColor = [UIColor clearColor];
        self.author.font = [UIFont fontWithName:@"Candara" size:detailsFontSize];
        self.author.textColor = [[SSDB5 theme] colorForKey:@"slide_details_color"];
        self.author.textAlignment = NSTextAlignmentRight;
        topMargin += 15.f;
        height = 1.f;
        if (IS_IPAD)
        {
            topMargin += 20.f;
            height *= 2.2;
        }
        //bar
        UIImageView *bar = [[UIImageView alloc] initWithFrame:CGRectMake(leftMargin, topMargin, width, height)];
        [bar setImage:[UIImage imageNamed:@"bar.png"]];
        [self addSubview:bar];
        topMargin += 5.f;
        height = 12.f;
        float subWidth = 14.f;
        float subMargin = 4.f;
        if (IS_IPAD)
        {
            topMargin += 10.f;
            height *= 2.2;
            subWidth *= 2.2;
            subMargin *= 2.2;
        }
        //number of views
        UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(leftMargin, topMargin, subWidth, height)];
        [view setImage:[UIImage imageNamed:@"view.png"]];
        view.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:view];
        self.viewsNumber = [[UILabel alloc] initWithFrame:CGRectMake(leftMargin + subWidth + subMargin, topMargin, width / 3 - subWidth, height)];
        self.viewsNumber.textColor = [[SSDB5 theme] colorForKey:@"slide_details_color"];
        self.viewsNumber.font = [UIFont fontWithName:@"Candara" size:detailsFontSize];
        self.viewsNumber.backgroundColor = [UIColor clearColor];
        [self addSubview:self.viewsNumber];
        
        //number of likes
        UIImageView *like = [[UIImageView alloc] initWithFrame:CGRectMake(leftMargin + width/3, topMargin, subWidth, height)];
        [like setImage:[UIImage imageNamed:@"like.png"]];
        like.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:like];
        self.likesNumber = [[UILabel alloc] initWithFrame:CGRectMake(leftMargin + width/3 + subWidth + subMargin, topMargin, width / 3 - subWidth, height)];
        self.likesNumber.textColor = [[SSDB5 theme] colorForKey:@"slide_details_color"];
        self.likesNumber.font = [UIFont fontWithName:@"Candara" size:detailsFontSize];
        self.likesNumber.backgroundColor = [UIColor clearColor];
        [self addSubview:self.likesNumber];

        //number of downloads
        UIImageView *download = [[UIImageView alloc] initWithFrame:CGRectMake(leftMargin + width*2/3, topMargin, subWidth, height)];
        [download setImage:[UIImage imageNamed:@"downloadcell.png"]];
        download.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:download];
        self.downloadsNumber = [[UILabel alloc] initWithFrame:CGRectMake(leftMargin + width*2/3 + subWidth + subMargin, topMargin, width / 3 - subWidth, height)];
        self.downloadsNumber.textColor = [[SSDB5 theme] colorForKey:@"slide_details_color"];
        self.downloadsNumber.font = [UIFont fontWithName:@"Candara" size:detailsFontSize];
        self.downloadsNumber.backgroundColor = [UIColor clearColor];
        [self addSubview:self.downloadsNumber];
        
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
    self.viewsNumber.text = [NSString stringWithFormat:@"%d", data.numViews];
    self.likesNumber.text = [NSString stringWithFormat:@"%d", data.numFavorites];
    self.downloadsNumber.text = [NSString stringWithFormat:@"%d", data.numFavorites];
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
