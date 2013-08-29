//
//  SSSlideShowControlView.h
//  SSlide
//
//  Created by iNghia on 8/24/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import "SSView.h"

@protocol SSSlideShowControlViewDelegate <NSObject>

- (void)downloadCurrentSlideDel;
- (void)startStreamingCurrentSlideDel;
- (BOOL)isMasterDel;
- (void)startDrawing;
- (void)stopDrawing;
- (void)clearDrawing;

@end

@interface SSSlideShowControlView : SSView

- (void)setDownloadProgress:(float)percent;
- (void)setFinishDownload;

@end
