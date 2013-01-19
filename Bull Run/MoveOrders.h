//
//  MoveOrders.h
//  Bull Run
//
//  Created by Dave Townsend on 1/18/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Hex.h"

// Tracks the list of hexes that a unit has been orders to move to.

@interface MoveOrders : NSObject <NSCopying>

@property (nonatomic) Hex* list;     // TODO: privatize
@property (nonatomic) int  capacity; // capacity of list
@property (nonatomic) int  count;    // # of valid items in list

// Designated initializer.
- (id)init;

// Returns YES if there are no orders
- (BOOL)isEmpty;

// Clears all movement orders
- (void)clear;

// Adds a hex to the end of the list
- (void)addHex:(Hex)hex;

// Returns number of hexes in list
- (int)numHexes;

// Gets most recently-added hex in the list.  Returns (-1,-1) if no orders.
- (Hex)lastHex;

// Gets first order in list, removing it if removeOrder == YES. Returns (-1,-1) if no orders.
- (Hex)firstHexAndRemove:(BOOL)removeOrder;

@end
