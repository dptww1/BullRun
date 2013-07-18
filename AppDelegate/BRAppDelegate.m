//
//  BRAppDelegate.m
//  Bull Run
//
//  Created by Dave Townsend on 12/13/12.
//  Copyright (c) 2012 Dave Townsend. All rights reserved.
//

#import "Beauregard.h"
#import "BRAppDelegate.h"
#import "BRGame.h"
#import "GameOptionsViewController.h"
#import "MapViewController.h"
#import "McDowell.h"
#import "MenuController.h"

@implementation BRAppDelegate

+ (BRAppDelegate*)app {
    return [[UIApplication sharedApplication] delegate];
}

#pragma mark - UIApplicationDelegate Callbacks

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    game = [[BRGame alloc] init];

    // Easiest to do this after `game` is assigned, so AI can use it
    //[game setAi:[[Beauregard alloc] init]];  // TODO: remove
    [game setAi:[[McDowell alloc] init]];    // TODO: remove

    _menuController = [[MenuController alloc] initForWindow:_window];

    MapViewController* mvController = [[MapViewController alloc] initWithNibName:nil bundle:nil];

    [[UIApplication sharedApplication] setStatusBarHidden:YES];

    [game addObserver:mvController];
    [_menuController pushController:mvController];

    [game doSighting:CSA]; // TODO: get rid of this once game setup works
    [[mvController animationList] run:nil];

    [_window makeKeyAndVisible];

    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
