//
//  SSUserViewController.m
//  SSlide
//
//  Created by iNghia on 8/21/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import "SSUserViewController.h"
#import "SSUserView.h"
#import "SSSettingsViewController.h"
#import <UIViewController+MJPopupViewController.h>

@interface SSUserViewController () <SSUserViewDelegate>

@property (strong, nonatomic) SSUserView *myView;

@end

@implementation SSUserViewController

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
    self.myView = [[SSUserView alloc] initWithFrame:self.view.bounds andDelegate:self];
    self.view = self.myView;
    
    /*
     [[SSApi sharedInstance] getSlideshowsByUser:@"rashmi"
     success:^(NSArray *result){
     self.pageManager = [[SSSlideShowPageManager alloc] initWithSlideshow:[result objectAtIndex:0]];
     dispatch_apply([result count], dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(size_t index) {
     SSSlideshow *slideshow = [result objectAtIndex:index];
     [[SSApi sharedInstance] addExtendedSlideInfo:slideshow];
     });
     
     }
     failure:^(void) {     // TODO: error handling
     NSLog(@"search ERROR");
     }];
     
     double delayInSeconds = 3.0;
     dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
     dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
     [self.pageManager refresh];
     [self presentViewController:self.pageManager.pageViewController animated:YES completion:nil];
     });
     */
    
    
    /*
     [[SSApi sharedInstance] checkUsernamePassword:@"thefoolishman"
     password:@"fasdf"
     result:^(BOOL result) {
     if(result) {
     NSLog(@"OK");
     } else {
     NSLog(@"FAIL");
     }
     }];
     */


}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - SSUserViewDelegate
- (void)segmentedControlChangedDel:(NSUInteger)index
{
    
}

- (void)settingsBtnPressedDel
{
    SSSettingsViewController *settingsViewController = [[SSSettingsViewController alloc] init];
    [self presentPopupViewController:settingsViewController animationType:MJPopupViewAnimationSlideBottomBottom];
}

@end
