//
//  MenuController.h
//
//  Created by Dave Townsend on 7/18/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Abstracts away some of the pecadilloes of the UINavigationController.
 * It doesn't do a lot, but it make some of the setup code a little nicer.
 */
@interface MenuController : NSObject

/** 
 * A `UINavigationController` instance available to clients. This is
 * initially empty until one or more `pushController` calls are made.
 */
@property (nonatomic, readonly, strong) UINavigationController* navController;

/**
 * Designated initializer.
 *
 * @param window the window whose contents the `MenuController` is managing.
 *
 * @return the initialized `MenuController`
 */
- (id)initForWindow:(UIWindow*)window;

/**
 * Activates a view controller by pushing it to the `UINavigationController`
 * stack.
 *
 * @param controller the view controller to activate
 */
- (void)pushController:(UIViewController*)controller;

@end
