//
//  BRAppDelegate.h
//  Bull Run
//
//  Created by Dave Townsend on 12/13/12.
//  Copyright (c) 2012 Dave Townsend. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Hex.h"

@class Unit;

@interface BRAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)unitNowSighted:(Unit*)unit;
- (void)unitNowHidden:(Unit*)unit;
- (void)moveUnit:(Unit*)unit to:(Hex)hex;
@end
