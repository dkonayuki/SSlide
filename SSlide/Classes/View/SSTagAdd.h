//
//  SSTagAdd.h
//  SSlide
//
//  Created by techcamp on 2013/08/26.
//  Copyright (c) 2013年 S2. All rights reserved.
//

#import "SSView.h"

@protocol SSTagAddDelegate <NSObject>

- (void) addTag:(NSString *)name;

@end

@interface SSTagAdd : SSView

@end
