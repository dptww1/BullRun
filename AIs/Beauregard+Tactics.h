//
//  Beauregard+Tactics.h
//  Bull Run
//
//  Created by Dave Townsend on 6/16/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import "Beauregard.h"


/**
 * Tactical module for CSA AI. This category contains internal methods only.
 */
@interface Beauregard (Tactics)

/**
 * Evaluates attack possibilities of all CSA units, and sets up attacks.
 */
- (void)assignAttackers;

/**
 * Assigns a defender, if possible.
 *
 * @return `YES` if a defender was assigned, `NO` if not possible
 */
- (BOOL)assignDefender:(BATAIInfluenceMap*)imap;

/**
 * Assigns the orders needed to move a unit to a given destination.
 * A maximum of two hexes are ordered, since no unit can move more than
 * that number of hexes in any given turn.
 *
 * @param unit the unit to order
 * @param destination the destination hex
 */
- (void)routeUnit:(BATUnit*)unit toDestination:(HXMHex)destination;

@end
