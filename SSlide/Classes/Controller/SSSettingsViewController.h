//
//  SSSettingsViewController.h
//  SSlide
//
//  Created by iNghia on 8/23/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import "SSViewController.h"

@protocol SSSettingsViewControllerDelegate <NSObject>

- (void)reloadSettingsDataDel;

@end

@interface SSSettingsViewController : SSViewController

- (id)initWithDelegate:(id)delegate;

@property (weak, nonatomic) id delegate;

@end
