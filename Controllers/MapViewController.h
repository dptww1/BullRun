//
//  MapViewController.h
//  Bull Run
//
//  Created by Dave Townsend on 12/24/12.
//  Copyright (c) 2012 Dave Townsend. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BAGameObserving.h"
#import "HMHex.h"

@class BAUnit;
@class HMCoordinateTransformer;
@class InfoBarView;
@class OrderOfBattle;

@interface MapViewController : UIViewController <BAGameObserving>

@property (nonatomic, strong) HMCoordinateTransformer* coordXformer;
@property (nonatomic, weak)   InfoBarView*             infoBarView;
@property (nonatomic, weak)   BAUnit*                    currentUnit;
@property (nonatomic, strong) CALayer*                 moveOrderLayer;

// If YES, then the user's touch has moved outside the current hex and
// so we are setting new movement orders.  This means that new touches
// (drags, really) into the current unit's original hex are treated like
// any other hex.
@property (nonatomic)         BOOL                     givingNewOrders;

// Key: NSString* (unit name)
// Value: CAKeyframeAnimation
@property (nonatomic, strong) NSMutableDictionary*     animationInfo;

#pragma mark - GameObserving Implementation

- (void)unitNowSighted:(BAUnit*)unit;
- (void)unitNowHidden:(BAUnit*)unit;

- (void)movePhaseWillBegin;
- (void)movePhaseDidEnd;

- (void)moveUnit:(BAUnit*)unit to:(HMHex)hex;
- (void)showAttack:(BABattleReport*)report;

@end
