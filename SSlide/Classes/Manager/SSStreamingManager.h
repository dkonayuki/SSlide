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
- (void)didAddPointsFromMasterDel:(NSArray *)points;
- (void)didClearFromMasterDel;
- (void)didEndTouchFromMasterDel;
- (void)disconnectedFromServerDel;
- (void)displayConnectedMessage:(NSString *)mes withTitle:(NSString *)title;
- (void)didHasNewQuestion:(NSString *)question;

@end

@interface SSStreamingManager : NSObject

@property (weak, nonatomic) id delegate;
@property (strong, nonatomic) NSMutableArray *questions;

- (id)initWithSlideshow:(SSSlideshow *)curSlide asMaster:(BOOL)isMaster;
- (BOOL)startSynchronizing;
- (void)stopSynchronizing;

- (BOOL)isMasterDevice;
- (BOOL)isStreamingAsClient;

- (void)gotoPageWithNum:(NSUInteger)pageNum;
- (void)didAddPointsInDrawingView:(NSArray *)points;
- (void)didClearDrawingView;
- (void)didEndTouchDrawingView;
- (void)sendQuestion:(NSString *)question;

@end
