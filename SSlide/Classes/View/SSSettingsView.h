//
//  SSSettingsView.h
//  SSlide
//
//  Created by iNghia on 8/23/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import "SSView.h"

@protocol SSSettingsViewDelegate <SSViewDelegate>

- (void)loginActionDel:(NSString *)username password:(NSString *)password;
- (void)logoutActionDel;
- (BOOL)isLogined;
- (NSMutableArray *)getTagStringsDel;

@end

@interface SSSettingsView : SSView

- (void)refreshPosition;

@end
