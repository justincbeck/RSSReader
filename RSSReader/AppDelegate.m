//
//  JCBAppDelegate.m
//  RSSReader
//
//  Created by Justin Beck on 12/12/11.
//  Copyright (c) 2011 BeckProduct. All rights reserved.
//

#import "AppDelegate.h"
#import "ReaderTableViewController.h"

#import "AFNetworkActivityIndicatorManager.h"

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];

    ReaderTableViewController *viewController = [[ReaderTableViewController alloc] init];
    viewController.title = @"Reader";
    
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [viewController release];
    
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];  
    _window.backgroundColor = [UIColor whiteColor];
    _window.rootViewController = navController;
    [navController release];
    
    [_window makeKeyAndVisible];
    
    return YES;
}

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

@end
