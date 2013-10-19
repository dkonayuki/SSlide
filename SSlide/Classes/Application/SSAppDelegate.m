//
//  SSAppDelegate.m
//  SSlide
//
//  Created by iNghia on 8/21/13.
//  Copyright (c) 2013 S2. All rights reserved.
//

#import "SSAppDelegate.h"
#import "SSAppData.h"
#import <NewRelicAgent/NewRelicAgent.h>

@implementation SSAppDelegate

#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [NewRelicAgent startWithApplicationToken:[[SSDB5 theme] stringForKey:@"NEW_RELIC_TOKEN"]];
    // load data
    [SSAppData sharedInstance];
    // init window
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    if (IS_IPAD) {
        self.window.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgipad.png"]];
    } else if (IS_IPHONE_5) {
        self.window.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bgip5.png"]];
    } else {
        self.window.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"bg.png"]];
    }
    // create root view controller
    self.rootViewController = [[SSRootViewController alloc] init];
    self.window.rootViewController = self.rootViewController;
    // make visible
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [SSAppData saveAppData];
}

@end
