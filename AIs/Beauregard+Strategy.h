//
//  Beauregard+Strategy.h
//  Bull Run
//
//  Created by Dave Townsend on 6/9/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import "Beauregard.h"


@class BATGame;
@class BAUnit;


/** 
 * Strategy module for CSA AI. This category contains internal methods only.
 */
@interface Beauregard (Strategy)

/**
 * Figures out which units should be assigned to which theaters.
 *
 * @param game the game to analyze
 */
- (void)strategize:(BATGame*)game;

/**
 * Figures out which theater a given unit is in.
 *
 * @param unit the unit to check
 *
 * @return the unit's theater
 */
- (BRAICSATheater)computeTheaterOf:(BAUnit*)unit;

/**
 * Orders units which are located in one theater but strategically
 * allocated to the other theater.
 */
- (void)conductStrategicMovement;

/**
 * Assigns the orders needed to move a unit to a given destination.
 * A maximum of two hexes are ordered, since no unit can move more than
 * that number of hexes in any given turn.
 *
 * @param unit the unit to order
 * @param destination the destination hex
 *
 * TODO: probably belongs in Tactics, actually
 */
- (void)routeUnit:(BAUnit*)unit toDestination:(HXMHex)destination;

@end
