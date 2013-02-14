//
//  MoveOrders.h
//  Bull Run
//
//  Created by Dave Townsend on 1/18/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HMHex.h"

@class ResizableBuffer;

// Tracks the list of hexes that a unit has been given orders to move to.

@interface MoveOrders : NSObject <NSCopying>

@property (nonatomic, strong) ResizableBuffer* list;

// Designated initializer.
- (id)init;

// Returns YES if there are no orders
- (BOOL)isEmpty;

// Clears all movement orders
- (void)clear;

// Adds a hex to the end of the list
- (void)addHex:(HMHex)hex;

// Returns number of hexes in list
- (int)numHexes;

// Gets most recently-added hex in the list.  Returns (-1,-1) if no orders.
- (HMHex)lastHex;

// Gets first order in list, removing it if removeOrder == YES. Returns (-1,-1) if no orders.
- (HMHex)firstHexAndRemove:(BOOL)removeOrder;

// Gets hex at given position, which must be in range (0..lastHex).  If outside that range,
// returns (-1,-1).  Position 0 represents the oldest hex.  Position [lastHex] represents
// the most recently-added hex.
- (HMHex)hex:(int)idx;

// Detects a backtrack situation, where the user chooses hex A, moves to hex B, then back
// to hex A.  Returns YES if "hex" is the same as the penultimate hex in the orders.
- (BOOL)isBacktrack:(HMHex)hex;

// Handles the situation described in isBacktrack by removing the last order in the list.
- (void)backtrack;

@end
