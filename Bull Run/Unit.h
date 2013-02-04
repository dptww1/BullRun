//
//  Unit.h
//  Bull Run
//
//  Created by Dave Townsend on 1/5/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BullRun.h"
#import "Hex.h"

@class MoveOrders;

@interface Unit : NSObject <NSCoding>

#pragma mark - Read-only Properties

@property (readonly) NSString*       name;
@property (readonly) PlayerSide      side;
@property (readonly) int             originalStrength;
@property (readonly) int             leadership;        // represents leadership, initiative, training; higher numbers are better
@property (readonly) int             morale;            // percentage of casualties which wrecks a unit (so higher numbers are better)
@property (readonly) int             imageXIdx;         // horizontal index (in cells, not pixels) of portrait image
@property (readonly) int             imageYIdx;         // vertical index (in cells, not pixels) or portrait image

#pragma mark - Modifiable Properties

@property            int             strength;
@property            Hex             location;
@property            BOOL            sighted;           // non-persistent; if TRUE, is visible to the enemy
@property (strong)   MoveOrders*     moveOrders;        // non-persistent
@property            Mode            mode;
@property            int             mps;               // Movement points

#pragma mark - Convenience Methods

// Returns YES if the unit has at least one movement order
- (BOOL)hasOrders;

// Returns YES if the receiver is on the same side as 'other'
- (BOOL)friends:(Unit*)other;

@end
