//
//  MapViewController.h
//  Bull Run
//
//  Created by Dave Townsend on 12/24/12.
//  Copyright (c) 2012 Dave Townsend. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HexMapCoordinateTransformer;
@class InfoBarView;
@class OrderOfBattle;
@class Unit;

@interface MapViewController : UIViewController

@property (nonatomic, strong) HexMapCoordinateTransformer* coordXformer;
@property (nonatomic, weak)   InfoBarView*                 infoBarView;
@property (nonatomic, weak)   Unit*                        currentUnit;
@property (nonatomic, weak)   CALayer*                     moveOrderLayer;
@property (nonatomic, strong) NSMutableArray*              moveOrderWayPoints;

// If YES, then the user's touch has moved outside the current hex and
// so we are setting new movement orders.  This means that new touches
// (drags, really) into the current unit's original hex are treated like
// any other hex.
@property (nonatomic)         BOOL                         givingNewOrders;

- (void)unitNowSighted:(Unit*)unit;
- (void)unitNowHidden:(Unit*)unit;

@end
