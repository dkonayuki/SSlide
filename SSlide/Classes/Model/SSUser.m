//
//  SSUser.m
//  SSlide
//
//  Created by iNghia on 8/23/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import "SSUser.h"

@implementation SSUser
@synthesize username = mUsername;
@synthesize password = mPassword;
@synthesize tags;

- (id)initWith:(NSString *)username password:(NSString *)password
{
    self = [super init];
    if (self) {
        self.username = username;
        self.password = password;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super init]) {
        mUsername = [aDecoder decodeObjectForKey:@"mUsername"];
        mPassword = [aDecoder decodeObjectForKey:@"mPassword"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:mUsername forKey:@"mUsername"];
    [aCoder encodeObject:mPassword forKey:@"mPassword"];
}

@end
