//
//  SSSlideShowControlView.h
//  SSlide
//
//  Created by iNghia on 8/24/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import "SSView.h"

@protocol SSSlideShowControlViewDelegate <SSViewDelegate>

- (void)downloadCurrentSlideDel;
- (void)startStreamingCurrentSlideDel;
- (void)stopStreamingCurrentSlideDel;
- (BOOL)isMasterDel;
- (void)startDrawing;
- (void)stopDrawing;
- (void)clearDrawing;
- (BOOL)slideIdDownloaded;

@end

@interface SSSlideShowControlView : SSView

- (void)setDownloadProgress:(float)percent;
- (void)setFinishDownload;
- (void)offStreamingBtn;

@end
