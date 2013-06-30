//
//  MapViewController.h
//  Bull Run
//
//  Created by Dave Townsend on 12/24/12.
//  Copyright (c) 2012 Dave Townsend. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "BATGameObserving.h"
#import "HexMap.h"


@class BATAnimationList;
@class BATBattleReport;
@class BATUnit;
@class InfoBarView;
@class OrderOfBattle;


/**
 * Main game view (which is the map) controller.
 */
@interface MapViewController : UIViewController <BATGameObserving>

/** The coordinate transformer for this view. */
@property (nonatomic, strong) HXMCoordinateTransformer* coordXformer;

/** The Info subview of this view. */
@property (nonatomic, weak)   InfoBarView*              infoBarView;

/** The currently-selected unit, possibly `nil`. */
@property (nonatomic, weak)   BATUnit*                  currentUnit;

/** The layer for movement orders. */
@property (nonatomic, strong) CALayer*                  moveOrderLayer;

/**
 * Tracks if the user's touch has moved outside the current hex. If `YES`,
 * then we know we are setting new movement orders, in which case new touches
 * (drags, really) into the unit's original hex are treated like any other hex.
 * If `NO`, then the user has never dragged outside the current hex, so the
 * unit's current orders still obtain.
 */
@property (nonatomic)         BOOL                      givingNewOrders;

/** List of animations to show for the current turn. */
@property (nonatomic, strong) BATAnimationList*         animationList;

#pragma mark - GameObserving Implementation

/** GameObserving method implementation. */
- (void)unitNowSighted:(BATUnit*)unit;

/** GameObserving method implementation. */
- (void)unitNowHidden:(BATUnit*)unit;

/** GameObserving method implementation. */
- (void)movePhaseWillBegin;

/** GameObserving method implementation. */
- (void)movePhaseDidEnd;

/** GameObserving method implementation. */
- (void)moveUnit:(BATUnit*)unit to:(HXMHex)hex;

/** GameObserving method implementation. */
- (void)showAttack:(BATBattleReport*)report;

@end
