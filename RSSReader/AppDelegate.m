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
    NSURLCache *urlCache = [[[NSURLCache alloc] initWithMemoryCapacity:1024 * 1024 diskCapacity:1024 * 1024 * 5 diskPath:nil] autorelease];
    [NSURLCache setSharedURLCache:urlCache];
    
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];

    ReaderTableViewController *viewController = [[[ReaderTableViewController alloc] init] autorelease];
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];  
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = viewController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

@end
