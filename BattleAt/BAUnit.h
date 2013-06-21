//
//  BAUnit.h
//  Bull Run
//
//  Created by Dave Townsend on 1/5/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BullRun.h"
#import "HXMHex.h"

@class BAMoveOrders;

/**
 * A game unit. No designated initializer because units should be loaded
 * from a file anyway.
 */
@interface BAUnit : NSObject <NSCoding>

#pragma mark - Read-only Properties

/** The unit's name. */
@property (nonatomic, readonly, copy)   NSString*       name;

/** The side that the unit is on. */
@property (nonatomic, readonly, assign) PlayerSide      side;

/** The original strength of the unit. */
@property (nonatomic, readonly, assign) int             originalStrength;

/** Represents leadership, initiative, training; higher numbers are better. */
@property (nonatomic, readonly, assign) int             leadership;

/** Percentage of casualties which wrecks a unit (so higher numbers are better) */
@property (nonatomic, readonly, assign) int             morale;

/** Horizontal index (in cells, not pixels) of portrait image. */
@property (nonatomic, readonly, assign) int             imageXIdx;

/** Vertical index (in cells, not pixels) or portrait image. */
@property (nonatomic, readonly, assign) int             imageYIdx;

#pragma mark - Modifiable Properties

/** The current strength of the unit. */
@property (nonatomic, assign)           int             strength;

/** The current hex location of the unit. */
@property (nonatomic, assign)           HXMHex          location;

/** If `YES`, the unit is visible to the enemy. */
@property (nonatomic, assign)           BOOL            sighted;

/** The movement orders for this unit. */
@property (nonatomic, strong)           BAMoveOrders*   moveOrders;

/** The unit's current mode. */
@property (nonatomic, assign)           Mode            mode;

/** The unit's movement points.  Sorry, "mps" was just too convenient. */
@property (nonatomic, assign)           int             mps;

/** 
 * The turn that the unit will appear; 0 means it starts on map.
 * Not truly public; entirely for the use the order of battle class.
 */
@property (nonatomic, assign)           int             turn;

#pragma mark - Convenience Methods

/**
 * Determines if this unit has any movement orders.
 *
 * @return `YES` if the unit has at least one order, `NO` if it has none
 */
- (BOOL)hasOrders;

/**
 * Determines if this unit is on the same side as another unit.
 *
 * @param other the other unit
 *
 * @return `YES` if the units are on the same side, `NO` if they aren't
 */
- (BOOL)friends:(BAUnit*)other;

/**
 * Determines if this unit is wrecked, meaning casualties are greater than
 * its `morale` percentage.
 *
 * @return `YES` if the unit is wrecked, `NO` if it isn't
 */
- (BOOL)isWrecked;

/**
 * Determines if the unit is on map, or off. Units don't know about the
 * exact geometry of your map, so for purposes of this method only negative
 * coordinates are considered offmap.
 *
 * @return `YES` if the unit's location if offmap, `NO` if it's onmap.
 */
- (BOOL)isOffMap;
@end
