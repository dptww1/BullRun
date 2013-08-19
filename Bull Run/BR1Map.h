//
//  BR1Map.h
//  Bull Run
//
//  Created by Dave Townsend on 5/10/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import "BattleAt.h"
#import "HexMap.h"
#import "BullRun.h"

/**
 * The Bull Run-specific game map.  Mostly exists as a place to
 * encapsulate some `HMMap` extensions that aren't general enough to
 * belong in `BRGame`.
 */
@interface BR1Map : HXMMap

/** 
 * Gets the global map instance, cast to the correct type. 
 * 
 * @return the map
 */
+ (BR1Map*)map;

/**
 * Determines if a hex is in enemy territory.
 *
 * @param hex the hex to check
 * @param side the side to check
 *
 * @return `YES` if the hex is in enemy territory, `NO` if it isn't
 */
- (BOOL)isHex:(HXMHex)hex enemyOfPlayer:(PlayerSide)side;

/**
 * Finds the closes ford to the given hex
 *
 * @param hex the hex in question
 *
 * @return the closest ford, and the distance to it
 */
- (HXMHexAndDistance)closestFordTo:(HXMHex)hex;

/**
 * Finds the base(s) for the given side.
 *
 * @param side the side to find bases for
 *
 * @return array of `NSValue`-encoded `HMHex`es where the side's bases are
 */
- (NSArray*)basesForSide:(PlayerSide)side;

@end
