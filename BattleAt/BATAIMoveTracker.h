//
//  BATAIMoveTracker.h
//
//  Created by Dave Townsend on 6/24/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HexMap.h"


@class BATUnit;


/**
 * Tracks movement cross-sectionally, allowing easy lookup
 * to see whether a given hex is occupied at a given point
 * during the turn.  Only one unit is allowed per hex per impulse.
 *
 * The intention is to aid in avoiding traffic jams when
 * computing unit move orders, and it's faster (and perhaps cleaner)
 * to use a dedicated cache than to search through each unit's
 * move orders.
 */
@interface BATAIMoveTracker : NSObject

/**
 * Class creation utility.
 *
 * @return an initialized `BATAIMoveTracker` object.
 */
+ (id)tracker;

/**
 * Clears all cached information.
 */
- (void)clear;

/**
 * Remembers that a unit occupied a hex at a given point in the turn.
 * If there is already a unit there, it is overwritten with the given unit.
 *
 * @param unit the unit occupying the hex
 * @param hex the hex being occupied
 * @param impulse the time within a turn when the unit occupies the hex
 */
- (void)track:(BATUnit*)unit movingTo:(HXMHex)hex onImpulse:(int)impulse;

/**
 * Gets the unit occupying a hex at a given point in the turn.
 *
 * @param hex the hex to check
 * @param impulse the time within a turn to check
 *
 * @return the relevant unit, or `nil` if no unit is in the hex in the impulse
 */
- (BATUnit*)unitIn:(HXMHex)hex onImpulse:(int)impulse;

@end
