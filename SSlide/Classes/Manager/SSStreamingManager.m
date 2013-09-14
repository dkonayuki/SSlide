//
//  SSStreamingManager.m
//  SSlide
//
//  Created by iNghia on 9/13/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import "SSStreamingManager.h"
#import "FayeClient.h"
#import "SSAppData.h"
#import "SSDB5.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <AFNetworking/AFHTTPClient.h>
#import <AFJSONRequestOperation.h>

@interface SSStreamingManager() <FayeClientDelegate>

@property (strong, nonatomic) FayeClient *fayeClient;
@property (strong, nonatomic) SSSlideshow *currentSlide;
@property (strong, nonatomic) NSString *channel;
@property (assign, nonatomic) BOOL isMaster;
@property (assign, nonatomic) BOOL isStreaming;

@end

@implementation SSStreamingManager

- (id)initWithSlideshow:(SSSlideshow *)curSlide asMaster:(BOOL)isMaster
{
    self = [super init];
    if (self) {
        self.currentSlide = curSlide;
        self.isMaster = isMaster;
        self.isStreaming = NO;
        if (!self.isMaster) {
            self.channel = self.currentSlide.channel;
        }
    }
    return self;
}

- (void)startSynchronizing
{
    if (self.isStreaming) {
        return;
    }
    if (!self.isMaster) {
        [self startFaye];
    } else {
        [self startStreaming];
    }
}

- (void)stopSynchronizing
{
    if (!self.isStreaming) {
        return;
    }
    
    self.isStreaming = NO;
    [SVProgressHUD showErrorWithStatus:@"Disconnected"];
    
    if (self.isMaster) {
        NSString *curUsername = [SSAppData sharedInstance].currentUser.username;
        
        AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[[SSDB5 theme] stringForKey:@"SS_SERVER_BASE_URL"]]];
        [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
        [client setDefaultHeader:@"Accept" value:@"application/json"];
        
        NSString *url = [NSString stringWithFormat:@"streaming/remove"];
        NSDictionary *params = @{@"username": curUsername,
                                 @"channel": self.channel};
        
        [client postPath:url
              parameters:params
                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                     NSDictionary *dict = (NSDictionary *)responseObject;
                     NSLog(@"%@", dict);
                 }
                 failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                     NSLog(@"error");
                 }];
    }
    [self.fayeClient disconnectFromServer];
}

- (BOOL)isMasterDevice
{
    return self.isMaster;
}

- (void)gotoPageWithNum:(NSUInteger)pageNum
{
    if (!self.isMaster || !self.isStreaming) {
        return;
    }
    SSUser *currentUser = [[SSAppData sharedInstance] currentUser];
    NSNumber *pn = [NSNumber numberWithInt:pageNum];
    NSDictionary *mesg = @{@"mestype": @"1",
                           @"username": currentUser.username,
                           @"pagenum": pn};
    [self.fayeClient sendMessage:mesg onChannel:self.channel];
}

- (void)didAddPointsInDrawingView:(NSArray *)points
{
    if (!self.isMaster || !self.isStreaming) {
        return;
    }
    
    SSUser *currentUser = [[SSAppData sharedInstance] currentUser];
    NSMutableString *pStr = [[NSMutableString alloc] init];
    for (NSValue *value in points) {
        CGPoint p = [value CGPointValue];
        [pStr appendString:[NSString stringWithFormat:@"%.2f %.2f ", p.x, p.y]];
    }
    NSDictionary *mesg = @{@"mestype": @"2",
                           @"username": currentUser.username,
                           @"points": pStr};
    [self.fayeClient sendMessage:mesg onChannel:self.channel];
}

- (void)didClearDrawingView
{
    if (!self.isMaster || !self.isStreaming) {
        return;
    }
    
    SSUser *currentUser = [[SSAppData sharedInstance] currentUser];
    NSDictionary *mesg = @{@"mestype": @"3",
                           @"username": currentUser.username};
    [self.fayeClient sendMessage:mesg onChannel:self.channel];
}

- (void)didEndTouchDrawingView
{
    if (!self.isMaster || !self.isStreaming) {
        return;
    }
    
    SSUser *currentUser = [[SSAppData sharedInstance] currentUser];
    NSDictionary *mesg = @{@"mestype": @"4",
                           @"username": currentUser.username};
    [self.fayeClient sendMessage:mesg onChannel:self.channel];
}

#pragma mark - Faye Client Delegate
- (void)connectedToServer
{
    NSString *mes = self.isMaster ? @"Publish: OK" : @"Subscribe: OK";
    self.isStreaming = YES;
    [SVProgressHUD showSuccessWithStatus:mes];
}

- (void)disconnectedFromServer
{
    NSLog(@"Disconnected from server");
    [self stopSynchronizing];
    [self.delegate disconnectedFromServerDel];
}

- (void)subscriptionFailedWithError:(NSString *)error
{
    NSLog(@"Subscription did fail: %@", error);
}

- (void)subscribedToChannel:(NSString *)channel
{
    NSLog(@"Subscribed to channel: %@", channel);
}

- (void)messageReceived:(NSDictionary *)messageDict channel:(NSString *)channel
{
    if (self.isMaster) {
        return;
    }
    
    NSUInteger mesType = [((NSNumber *)[messageDict objectForKey:@"mestype"]) integerValue];
    switch (mesType) {
        case 1: // change page
        {
            NSUInteger pageNum = [((NSNumber *)[messageDict objectForKey:@"pagenum"]) integerValue];
            [self.delegate gotoPageWithNumDel:pageNum];
        }
            break;
        case 2: // drawing
        {
            NSString *pStr = [messageDict objectForKey:@"points"];
            NSArray *value = [pStr componentsSeparatedByString:@" "];
            NSMutableArray *pArray = [[NSMutableArray alloc] init];
            for (int i = 0; i < value.count - 1; i+=2) {
                CGPoint p = CGPointMake([[value objectAtIndex:i] floatValue],
                                         [[value objectAtIndex:i + 1] floatValue]);
                [pArray addObject:[NSValue valueWithCGPoint:p]];
            }
            [self.delegate didAddPointsFromMasterDel:pArray];
        }
            break;
        case 3: // clear
        {
            [self.delegate didClearFromMasterDel];
        }
            break;
        case 4: // did end touch
        {
            [self.delegate didEndTouchFromMasterDel];
        }
        default:
            break;
    }
}

- (void)connectionFailed
{
    NSLog(@"Connection Failed");
    [SVProgressHUD showErrorWithStatus:@"Connection Failed!"];
}

- (void)didSubscribeToChannel:(NSString *)channel
{
    NSLog(@"didSubscribeToChannel %@", channel);
}

- (void)didUnsubscribeFromChannel:(NSString *)channel
{
    NSLog(@"didUnsubscribeFromChannel %@", channel);
}

- (void)fayeClientError:(NSError *)error
{
    NSLog(@"fayeClientError %@", error);
}

#pragma mark - private
- (void)startStreaming
{
    // checklogin
    if (![[SSAppData sharedInstance] isLogined]) {
        [SVProgressHUD showErrorWithStatus:@"Please login!"];
        return;
    }
    
    NSString *curUsername = [SSAppData sharedInstance].currentUser.username;
    self.channel = [NSString stringWithFormat:@"/%@/%@", curUsername, self.currentSlide.slideId];
    
    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[[SSDB5 theme] stringForKey:@"SS_SERVER_BASE_URL"]]];
    [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [client setDefaultHeader:@"Accept" value:@"application/json"];
    
    NSString *url = [NSString stringWithFormat:@"streaming/create"];
    NSDictionary *params = @{@"username": curUsername,
                             @"channel": self.channel,
                             @"slideId": self.currentSlide.slideId,
                             @"title": self.currentSlide.title,
                             @"thumbnailUrl": self.currentSlide.thumbnailUrl,
                             @"created": self.currentSlide.created,
                             @"numViews": [NSNumber numberWithInt:self.currentSlide.numViews],
                             @"numDownloads": [NSNumber numberWithInt:self.currentSlide.numDownloads],
                             @"numFavorites": [NSNumber numberWithInt:self.currentSlide.numFavorites],
                             @"totalSlides": [NSNumber numberWithInt:self.currentSlide.totalSlides],
                             @"slideImageBaseurl": self.currentSlide.slideImageBaseurl,
                             @"slideImageBaseurlSuffix": self.currentSlide.slideImageBaseurlSuffix,
                             @"firstPageImageUrl": self.currentSlide.firstPageImageUrl};
    
    [client postPath:url
          parameters:params
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 [self startFaye];
             }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 [SVProgressHUD showErrorWithStatus:@"Error!"];
             }];
}

- (void)startFaye
{
    self.fayeClient = [[FayeClient alloc] initWithURLString:[[SSDB5 theme] stringForKey:@"FAYE_BASE_URL"] channel:self.channel];
    self.fayeClient.delegate = self;
    [self.fayeClient connectToServer];
    [SVProgressHUD showWithStatus:@"Connecting"];
}

@end
