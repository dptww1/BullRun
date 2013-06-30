//
//  Beauregard.h
//  Bull Run
//
//  Created by Dave Townsend on 5/8/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BATAIDelegate.h"
#import "BullRun.h"
#import "HexMap.h"


/** Enum defining what strategic role a unit should fulfill. */
typedef enum {
    BRAICSARoleNone,        /**< no role; unit is offmap */
    BRAICSARoleDefendWest,  /**< unit should defend in the west */
    BRAICSARoleDefendEast   /**< unit should defend in the east */
} BRAICSARole;


/** Enum defining the "theaters" of the map. */
typedef enum {
    BRAICSATheaterWest, /**< west, near Gainesville */
    BRAICSATheaterEast  /**< east, near Manassas */
} BRAICSATheater;

/**
 * Finds the other theater than the parameter.
 *
 * @param X theater to find 
 */
#define OtherTheater(X) \
    ((X) == BRAICSATheaterWest ? BRAICSATheaterEast : BRAICSATheaterWest)


/** 
 * CSA AI 
 */
@interface Beauregard : NSObject <BATAIDelegate>

/** The side represented by this AI. */
@property (nonatomic, readonly, assign) PlayerSide side;

/** 
 * The strategic role assigned to each unit.
 * key: (NSString) unitName
 * value: (BRAICSARole) role
 */
@property (nonatomic, readonly, strong) NSMutableDictionary* unitRoles;

/** Contains the names of all units that are already ordered this turn. */
@property (nonatomic, readonly, strong) NSMutableSet* orderedThisTurn;


/** 
 * BATAIDelegate implementation.
 *
 * @param game the game to run free setup on
 */
- (void)freeSetup:(BATGame*)game;

/**
 * BATAIDelegate implementation.
 *
 * @param game the game instance to give orders to
 */
- (void)giveOrders:(BATGame*)game;

/**
 * Returns the hex of the base in the given theater
 *
 * @param theater to get base of
 */
- (HXMHex)baseHexForTheater:(BRAICSATheater)theater;

/**
 * Returns list of CSA units which are on the map but have not yet
 * been given orders.
 *
 * @return array of `BATUnit*`
 */
- (NSArray*)unorderedCsaUnits;

@end
