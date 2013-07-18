//
//  BRAppDelegate.h
//  Bull Run
//
//  Created by Dave Townsend on 12/13/12.
//  Copyright (c) 2012 Dave Townsend. All rights reserved.
//

#import <UIKit/UIKit.h>


@class MenuController;


/** The Bull Run-specific application delegate. */
@interface BRAppDelegate : UIResponder <UIApplicationDelegate>

/** The application window. */
@property (strong, nonatomic) UIWindow *window;

/** The root navigation control. */
@property (nonatomic, strong) MenuController* menuController;

+ (BRAppDelegate*)app;

@end
