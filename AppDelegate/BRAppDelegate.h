//
//  BRAppDelegate.h
//  Bull Run
//
//  Created by Dave Townsend on 12/13/12.
//  Copyright (c) 2012 Dave Townsend. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMHex.h"

@class Unit;

@interface BRAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)unitNowSighted:(Unit*)unit;
- (void)unitNowHidden:(Unit*)unit;
- (void)moveUnit:(Unit*)unit to:(HMHex)hex;
- (void)movePhaseWillBegin;
- (void)movePhaseDidEnd;
- (void)unit:(Unit*)attacker willAttack:(HMHex)hex;
- (void)unit:(Unit*)defender willRetreatTo:(HMHex)hex;
- (void)unit:(Unit*)attacker willAdvanceTo:(HMHex)hex;

@end
