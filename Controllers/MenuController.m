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
        [_navController setModalPresentationStyle:UIModalPresentationFormSheet];
        [window setRootViewController:_navController];
    }

    return self;
}

- (UIViewController*)topViewController {
    NSArray* stack = [_navController viewControllers];
    if (!stack || [stack count] == 0)
        return nil;

    int top = [stack count] - 1;
    return stack[top];
}

- (void)pushController:(UIViewController *)controller {
    // First push?
    UIViewController* topViewController = [self topViewController];
    if (!topViewController) {

        [_navController setViewControllers:@[ controller ]];

    } else { // stack already established
        [_navController setModalPresentationStyle:UIModalPresentationCurrentContext];
        [topViewController presentViewController:controller
                                        animated:YES
                                      completion:nil];
    }
}

- (NSString*)description {
    return [NSString stringWithFormat:@"<MenuController: 0x%p navController:%p stack: %@",
            self,
            _navController,
            _navController.viewControllers];
}

@end
