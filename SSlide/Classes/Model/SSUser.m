//
//  SSUser.m
//  SSlide
//
//  Created by iNghia on 8/23/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import "SSUser.h"
#import "SSDB5.h"

@implementation SSUser
@synthesize username = mUsername;
@synthesize password = mPassword;
@synthesize tags = mTags;

- (id)initWith:(NSString *)username password:(NSString *)password
{
    self = [super init];
    if (self) {
        self.username = username;
        self.password = password;
        self.tags = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)initDefaultUser
{
    self = [super init];
    if (self) {
        self.username = [[SSDB5 theme] stringForKey:@"defaul_username"];
        self.password = nil;
        self.tags = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super init]) {
        mUsername = [aDecoder decodeObjectForKey:@"mUsername"];
        mPassword = [aDecoder decodeObjectForKey:@"mPassword"];
        mTags = [aDecoder decodeObjectForKey:@"mTags"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:mUsername forKey:@"mUsername"];
    [aCoder encodeObject:mPassword forKey:@"mPassword"];
    [aCoder encodeObject:mTags forKey:@"mTags"];
}

@end
