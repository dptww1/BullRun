//
//  MenuController.m
//
//  Created by Dave Townsend on 7/18/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import "MenuController.h"


@interface MenuController ()

@property (nonatomic, readwrite, weak)   UIWindow* window;
@property (nonatomic, readwrite, strong) NSMutableArray* viewControllers;

@end

static MenuController* instance;


@implementation MenuController

+ (id)sharedInstance {
    return instance;
}

- (id)initForWindow:(UIWindow*)window {
    self = [super init];

    if (self) {
        _window = window;
        _viewControllers = [NSMutableArray array];

        instance = self;
    }

    return self;
}

- (void)pushController:(UIViewController*)controller {
    UIViewController* topViewController = [_viewControllers lastObject];
    
    // First push?
    if (!topViewController) {

        //[controller setDefinesPresentationContext:YES];
        [_window setRootViewController:controller];
        [controller setWantsFullScreenLayout:YES];

    } else { // stack already established
        [controller setModalPresentationStyle:UIModalPresentationFormSheet];

        CGRect nibBounds = controller.view.bounds;

        [topViewController presentViewController:controller
                                        animated:YES
                                      completion:nil];
        
        controller.view.superview.bounds = nibBounds;

        // NB: x,y reversed because we're in landscape mode
        controller.view.superview.center = CGPointMake(topViewController.view.center.y,
                                                       topViewController.view.center.x);
    }

    [_viewControllers addObject:controller];
}

- (void)popController {
    UIViewController* curViewController = [_viewControllers lastObject];
    [curViewController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    [_viewControllers removeLastObject];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"<MenuController: 0x%p stack: %@",
            self,
            _viewControllers];
}

@end
