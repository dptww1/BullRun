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

#pragma mark - Modifiable Properties

@property            int             strength;
@property            Hex             location;
@property            BOOL            sighted;           // if TRUE, is visible to the enemy
@property (strong)   MoveOrders*     moveOrders;
@property            Mode            mode;

#pragma mark - Initializers

- (id)initWithName:(NSString*)name side:(PlayerSide)side leadership:(int)leadership strength:(int)strength morale:(int)morale location:(Hex)hex;
@end
