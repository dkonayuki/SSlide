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
        }
        UIImageView *cellBg = [[UIImageView alloc] initWithFrame:CGRectMake(leftMargin, topMargin, width, height)];
        cellBg.backgroundColor = [[SSDB5 theme] colorForKey:@"cell_bg_color"];
        [self addSubview:cellBg];
        CALayer *layer = [cellBg layer];
        [layer setMasksToBounds:YES];
        [layer setCornerRadius:2.0];
        
        leftMargin += 2.f;
        width = 100.f;
        topMargin += 2.f;
        height -= 4.f;
        if (IS_IPAD)
        {
            width *= 2.2;
        }
        UIImageView *thumbnailBg = [[UIImageView alloc] initWithFrame:CGRectMake(leftMargin, topMargin, width, height)];
        thumbnailBg.backgroundColor = [[SSDB5 theme] colorForKey:@"thumbnail_bg_color"];
        [self addSubview:thumbnailBg];
        
        leftMargin += 2.f;
        width -= 4.f;
        topMargin += 2.f;
        height -= 4.f;
        self.thumbnail = [[UIImageView alloc] initWithFrame:CGRectMake(leftMargin, topMargin, width, height)];
        self.thumbnail.contentMode = UIViewContentModeScaleToFill;
        [self addSubview:self.thumbnail];
        
        leftMargin = leftMargin + width + 5.f;
        width = cellWidth - leftMargin - 20.f;
        topMargin = 12.f;
        height = 16.f;
        titleFontSize = 14.f;
        detailsFontSize = 11.f;
        if (IS_IPAD)
        {
            topMargin = topMargin * 2.2;
            height = height * 2.2;
            titleFontSize = titleFontSize * 1.5;
            detailsFontSize = detailsFontSize * 1.5;
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
            topMargin += 30.f;
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
            topMargin += 15.f;
            height *= 2.2;
        }
        UIImageView *bar = [[UIImageView alloc] initWithFrame:CGRectMake(leftMargin, topMargin, width, height)];
        [bar setImage:[UIImage imageNamed:@"bar.png"]];
        [self addSubview:bar];
        topMargin += 10.f;
        height = 15.f;
        if (IS_IPAD)
        {
            topMargin += 10.f;
            height *= 2.2;
        }
        UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(leftMargin, topMargin, width/3, height)];
        self.contentView.backgroundColor = [UIColor clearColor];
    }
    return self;
}

#pragma mark - setData
- (void)setData:(SSSlideshow *)data
{
    [self getThumbnail:[NSURL URLWithString:data.thumbnailUrl]];
    /*CGSize size = [data.title sizeWithFont:self.title.font
                         constrainedToSize:CGSizeMake(self.title.bounds.size.width,
                                                      2 * self.title.font.lineHeight)
                             lineBreakMode:self.title.lineBreakMode];
    CGRect newFrame = self.title.frame;
    newFrame.size.height = size.height;
    self.title.frame = newFrame;*/
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
