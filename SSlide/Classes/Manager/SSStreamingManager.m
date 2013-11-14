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
#import <FlatUIKit.h>
#import "SSQuestion.h"

@interface SSStreamingManager() <FayeClientDelegate>

@property (strong, nonatomic) FayeClient *fayeClient;
@property (strong, nonatomic) SSSlideshow *currentSlide;
@property (strong, nonatomic) NSString *channel;
@property (assign, nonatomic) BOOL isMaster;
@property (assign, nonatomic) BOOL isStreaming;
@property (strong, nonatomic) NSDictionary *messageTypeDic;

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
            self.channel = [NSString stringWithFormat:@"%@", self.currentSlide.channel];
        } else {
            NSString *curUsername = [SSAppData sharedInstance].currentUser.username;
            self.channel = [NSString stringWithFormat:@"/%@", curUsername];
        }
        
        self.questions = [[NSMutableArray alloc] init];
        self.messageTypeDic = @{@"move": @1,
                                @"draw": @2,
                                @"question": @3};
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
                     NSLog(@"OK");
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
    NSNumber *pn = [NSNumber numberWithInt:pageNum];
    NSDictionary *mesg = [self createMessageContent:@"move"
                                           andExtra:@{@"pageNum": pn}];
    [self.fayeClient sendMessage:mesg onChannel:self.channel];
}

- (void)didAddPointsInDrawingView:(NSArray *)points
{
    if (!self.isMaster || !self.isStreaming) {
        return;
    }
    
    NSMutableString *pStr = [[NSMutableString alloc] init];
    for (NSValue *value in points) {
        CGPoint p = [value CGPointValue];
        [pStr appendString:[NSString stringWithFormat:@"%.2f %.2f ", p.x, p.y]];
    }
    NSDictionary *mesg = [self createMessageContent:@"draw"
                                           andExtra:@{@"pointSet": pStr, @"status": @"dragging"}];
    [self.fayeClient sendMessage:mesg onChannel:self.channel];
}

- (void)didClearDrawingView
{
    if (!self.isMaster || !self.isStreaming) {
        return;
    }
    
    NSDictionary *mesg = [self createMessageContent:@"draw"
                                           andExtra:@{@"status": @"clear_drawing"}];
    [self.fayeClient sendMessage:mesg onChannel:self.channel];
}

- (void)didEndTouchDrawingView
{
    if (!self.isMaster || !self.isStreaming) {
        return;
    }
    
    NSDictionary *mesg = [self createMessageContent:@"draw"
                                           andExtra:@{@"status": @"end_dragging"}];
    [self.fayeClient sendMessage:mesg onChannel:self.channel];
}

- (void)sendQuestion:(NSString *)question atPage:(NSUInteger)pagenum
{
    if (self.isMaster || !self.isStreaming) {
        return;
    }
    
    NSDictionary *mesg = [self createMessageContent:@"question"
                                           andExtra:@{@"content": question, @"slide-page-num": [NSNumber numberWithInt:pagenum]}];
    [self.fayeClient sendMessage:mesg onChannel:self.channel];
}

- (BOOL)isStreamingAsClient
{
    return self.isStreaming && (!self.isMaster);
}

#pragma mark - Faye Client Delegate
- (void)connectedToServer
{
    NSString *mes;
    NSString *title;
    if (self.isMaster)
    {
        title = @"Publish successful";
        mes = [NSString stringWithFormat:@"Other devices can search \"#%@\" to subscribe.",[SSAppData sharedInstance].currentUser.username];
    }
    else
    {
        title = @"Subscription successful";
        mes = [NSString stringWithFormat:@"Your device is now syncing with %@'s device.", self.channel];
    }
    self.isStreaming = YES;
    [SVProgressHUD dismiss];
    [self displayConnectedMessage:mes withTitle:title];
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
    NSUInteger mesType = [[self.messageTypeDic objectForKey:[messageDict objectForKey:@"messageType"]] integerValue];
    NSDictionary *mesExtra = [messageDict objectForKey:@"messageExtra"];
    switch (mesType) {
        case 1: // change page
        {
            if (self.isMaster) {
                return;
            }
            NSUInteger pageNum = [((NSNumber *)[mesExtra objectForKey:@"pageNum"]) integerValue];
            [self.delegate gotoPageWithNumDel:pageNum];
        }
            break;
            
        case 2: // drawing
        {
            if (self.isMaster) {
                return;
            }
            NSString *status = [mesExtra objectForKey:@"status"];
            if([status isEqualToString:@"dragging"])
            {
                NSString *pStr = [mesExtra objectForKey:@"pointSet"];
                NSArray *value = [pStr componentsSeparatedByString:@" "];
                NSMutableArray *pArray = [[NSMutableArray alloc] init];
                for (int i = 0; i < value.count - 1; i+=2) {
                    CGPoint p = CGPointMake([[value objectAtIndex:i] floatValue],
                                            [[value objectAtIndex:i + 1] floatValue]);
                    [pArray addObject:[NSValue valueWithCGPoint:p]];
                }
                [self.delegate didAddPointsFromMasterDel:pArray];
                return;
            }
            
            if([status isEqualToString:@"end_dragging"])
            {
                [self.delegate didEndTouchFromMasterDel];
            }
            
            if([status isEqualToString:@"clear_drawing"])
            {
                [self.delegate didClearFromMasterDel];
            }
        }
            break;
            
        case 3: // question
        {
            if (!self.isMaster) {
                return;
            }
            NSString *content = [mesExtra objectForKey:@"content"];
            NSUInteger page =[((NSNumber *)[mesExtra objectForKey:@"slide-page-num"]) integerValue];
            SSQuestion *question = [[SSQuestion alloc] initWith:content
                                                        pagenum:page];
            [self.questions addObject:question];
            [self.delegate didHasNewQuestion:content];
        }
            break;
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
- (BOOL)startStreaming
{
    // checklogin
    if (![[SSAppData sharedInstance] isLogined]) {
        [SVProgressHUD showErrorWithStatus:@"Please login!"];
        return false;
    }

    AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:[[SSDB5 theme] stringForKey:@"SS_SERVER_BASE_URL"]]];
    [client registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [client setDefaultHeader:@"Accept" value:@"application/json"];
    
    NSString *url = [NSString stringWithFormat:@"/streaming/register"];
    NSDictionary *params = @{@"channel": self.channel,
                             @"slide_id": self.currentSlide.slideId};
    
    [client postPath:url
          parameters:params
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 [self startFaye];
             }
             failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 [SVProgressHUD showErrorWithStatus:@"Error!"];
             }];
    return true;
}

- (void)startFaye
{
    self.fayeClient = [[FayeClient alloc] initWithURLString:[[SSDB5 theme] stringForKey:@"FAYE_BASE_URL"] channel:self.channel];
    self.fayeClient.delegate = self;
    [self.fayeClient connectToServer];
    [SVProgressHUD showWithStatus:@"Connecting"];
}

- (void)displayConnectedMessage:(NSString *)message withTitle:(NSString *)title
{
    [self.delegate displayConnectedMessage:message withTitle:title];
}

- (NSDictionary *)createMessageContent:(NSString *)action andExtra:(NSDictionary *)extra
{
    NSString *curUsername = [SSAppData sharedInstance].currentUser.username;
    NSDictionary *mesg = @{@"messageType": action,
                           @"messageOwner": curUsername,
                           @"messageExtra": extra};
    return mesg;
}

@end
