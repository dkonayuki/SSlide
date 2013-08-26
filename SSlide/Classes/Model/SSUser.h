//
//  SSUser.h
//  SSlide
//
//  Created by iNghia on 8/23/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SSUser : NSObject <NSCoding>

@property (copy, nonatomic) NSString *username;
@property (copy, nonatomic) NSString *password;
@property (strong, nonatomic) NSMutableArray *tags;

- (id)initWith:(NSString *)username password:(NSString *)password;

@end
