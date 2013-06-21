//
//  BAMoveOrders.h
//  Bull Run
//
//  Created by Dave Townsend on 1/18/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HXMHex.h"

@class DPTResizableBuffer;

/**
 * Tracks the list of hexes that a unit has been given orders to move to. This
 * just manages the list; it's up to the caller to ensure that only legal hexes
 * are added.
 */
@interface BAMoveOrders : NSObject <NSCopying>

/**
 * Designated initializer.
 *
 * @return new empty move orders
 */
- (id)init;

/**
 * Determine if this set of move orders is empty
 *
 * @return `YES` if there are no orders, or `NO` if there is at least one order
 */
- (BOOL)isEmpty;

/**
 * Clears out all move orders from this list.
 */
- (void)clear;

/**
 * Appends a hex to the end of this list.
 *
 * @param hex the hex to add
 */
- (void)addHex:(HXMHex)hex;

/**
 * Returns number of hexes in this list.
 *
 * @return the number of hexes, possibly zero
 */
- (int)numHexes;

/**
 * Gets most recently-added hex in the list.  
 *
 * @return the last hex, or (-1,-1) if there is none because the list is empty
 */
//
- (HXMHex)lastHex;

/**
 * Gets first order in list, removing it if removeOrder == `YES`.
 *
 * @param removeOrder if `YES`, this is a pop operation; if `NO`, it's a peek
 *
 * @return the first hex in the list, or (-1,-1) if the list is empty
 */
//
- (HXMHex)firstHexAndRemove:(BOOL)removeOrder;

/**
 * Gets hex at given position, which must be in range (0..`lastHex:`).
 * Position 0 represents the oldest hex.  Position `lastHex:` represents
 * the most recently-added hex.
 *
 * The hex is not removed from the list.
 *
 * @param idx the index of the hex to retrieve.
 *
 * @return the corresponding hex, or (-1,-1) if `idx` is bad
 */
- (HXMHex)hex:(int)idx;

/**
 * Detects a backtrack where the user selects a unit in hex A, orders it to 
 * adjacent hex B, then orders it back to hex A.
 *
 * @param hex the hex under consideration 
 *
 * @return `YES` if "hex" is the same as the penultimate hex in the orders,
 *         else `NO`
 */
- (BOOL)isBacktrack:(HXMHex)hex;

/**
 * Handles the situation described in `isBacktrack:` by removing the last order
 * in the list.
 */
- (void)backtrack;

@end
