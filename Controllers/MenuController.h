//
//  MenuController.h
//
//  Created by Dave Townsend on 7/18/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MenuController : NSObject

@property (nonatomic, readonly, strong) UINavigationController* navController;

- (id)initForWindow:(UIWindow*)window;

- (void)pushController:(UIViewController*)controller;

@end
