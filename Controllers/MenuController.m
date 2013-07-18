//
//  MenuController.m
//
//  Created by Dave Townsend on 7/18/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import "MenuController.h"


@interface MenuController ()

@property (nonatomic, readwrite, strong) UINavigationController* navController;

@end


@implementation MenuController

- (id)initForWindow:(UIWindow*)window {
    self = [super init];

    if (self) {
        _navController = [[UINavigationController alloc]
                          initWithNavigationBarClass:nil
                          toolbarClass:nil];
        [_navController setNavigationBarHidden:YES];
        [window setRootViewController:_navController];
    }

    return self;
}

- (void)pushController:(UIViewController *)controller {
    // First push?
    if (![_navController viewControllers] ||
        [[_navController viewControllers] count] == 0) {

        [_navController setViewControllers:@[ controller ]];

    } else { // stack already established
        [_navController presentViewController:controller
                                     animated:YES
                                   completion:nil];
    }
}

@end
