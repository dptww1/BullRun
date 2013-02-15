//
//  MapViewController.h
//  Bull Run
//
//  Created by Dave Townsend on 12/24/12.
//  Copyright (c) 2012 Dave Townsend. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMHex.h"

@class HMCoordinateTransformer;
@class InfoBarView;
@class OrderOfBattle;
@class Unit;

@interface MapViewController : UIViewController

@property (nonatomic, strong) HMCoordinateTransformer* coordXformer;
@property (nonatomic, weak)   InfoBarView*             infoBarView;
@property (nonatomic, weak)   Unit*                    currentUnit;
@property (nonatomic, strong) CALayer*                 moveOrderLayer;

// If YES, then the user's touch has moved outside the current hex and
// so we are setting new movement orders.  This means that new touches
// (drags, really) into the current unit's original hex are treated like
// any other hex.
@property (nonatomic)         BOOL                     givingNewOrders;

// Key: NSString* (unit name)
// Value: CAKeyframeAnimation
@property (nonatomic, strong) NSMutableDictionary*     animationInfo;

- (void)unitNowSighted:(Unit*)unit;
- (void)unitNowHidden:(Unit*)unit;
- (void)moveUnit:(Unit*)unit to:(HMHex)hex;
- (void)movePhaseWillBegin;
- (void)movePhaseDidEnd;
- (void)unit:(Unit*)attacker willAttack:(HMHex)hex;
- (void)unit:(Unit*)defender willRetreatTo:(HMHex)hex;
- (void)unit:(Unit*)attacker willAdvanceTo:(HMHex)hex;

@end
