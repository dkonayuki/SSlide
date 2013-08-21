//
//  SSViewController.m
//  SSlide
//
//  Created by iNghia on 8/21/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import "SSViewController.h"

@interface SSViewController ()

@end

@implementation SSViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showAlertWithTitle:(NSString *)title andMessage:(NSString *)message andDelegate:(id)delegate
{
    // alert view
    self.alertView = [[FUIAlertView alloc] initWithTitle:title
                                                 message:message
                                                delegate:delegate
                                       cancelButtonTitle:@"OK"
                                       otherButtonTitles:nil, nil];
    self.alertView.titleLabel.textColor = [UIColor cloudsColor];
    self.alertView.titleLabel.font = [UIFont boldFlatFontOfSize:16];
    self.alertView.messageLabel.textColor = [UIColor cloudsColor];
    self.alertView.messageLabel.font = [UIFont flatFontOfSize:14];
    self.alertView.backgroundOverlay.backgroundColor = [[UIColor cloudsColor] colorWithAlphaComponent:0.8];
    self.alertView.alertContainer.backgroundColor = [UIColor midnightBlueColor];
    self.alertView.defaultButtonColor = [UIColor cloudsColor];
    self.alertView.defaultButtonShadowColor = [UIColor asbestosColor];
    self.alertView.defaultButtonFont = [UIFont boldFlatFontOfSize:16];
    self.alertView.defaultButtonTitleColor = [UIColor asbestosColor];
    [self.alertView show];
}

@end
