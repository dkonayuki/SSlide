//
//  SSViewController.h
//  SSlide
//
//  Created by iNghia on 8/21/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FUIAlertView.h>
#import <FlatUIKit/UIColor+FlatUI.h>
#import <FlatUIKit/UIFont+FlatUI.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "SSDB5.h"

@interface SSViewController : UIViewController

@property (strong, nonatomic) FUIAlertView *alertView;

- (void) showAlertWithTitle:(NSString *)title andMessage:(NSString *)message andDelegate:(id)delegate;

@end
