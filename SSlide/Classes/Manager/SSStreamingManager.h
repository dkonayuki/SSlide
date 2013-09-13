//
//  SSStreamingManager.h
//  SSlide
//
//  Created by iNghia on 9/13/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SSSlideshow.h"

@protocol SSStreamingManagerDelegate <NSObject>

- (void)gotoPageWithNumDel:(NSUInteger)pageNum;
- (void)disconnectedFromServerDel;

@end

@interface SSStreamingManager : NSObject

@property (weak, nonatomic) id delegate;

- (id)initWithSlideshow:(SSSlideshow *)curSlide asMaster:(BOOL)isMaster;
- (void)startSynchronizing;
- (void)stopSynchronizing;

- (void)gotoPageWithNum:(NSUInteger)pageNum;
- (BOOL)isMasterDevice;

@end
