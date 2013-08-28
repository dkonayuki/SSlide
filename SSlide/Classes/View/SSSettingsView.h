//
//  SSSettingsView.h
//  SSlide
//
//  Created by iNghia on 8/23/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import "SSView.h"

@protocol SSSettingsViewDelegate <NSObject>

- (void)loginActionDel;
- (void)logoutActionDel;
- (NSMutableArray *)getTagStringsDel;

@end

@interface SSSettingsView : SSView

@end
