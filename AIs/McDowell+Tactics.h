//
//  McDowell+Tactics.h
//  Bull Run
//
//  Created by Dave Townsend on 5/25/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import "McDowell.h"

@class BATAIInfluenceMap;

/** USA AI tactical thinking. */
@interface McDowell (Tactics)

/**
 * Assigns an attacker to the "attack" ford target, then a CSA base.
 *
 * @return `YES` if a unit was assigned, `NO` if no unit was assigned
 */
- (BOOL)assignAttacker;

/**
 * Assigns a defender to counter a CSA attack across the river.
 *
 * @param imap a filled-in influence map
 *
 * @return `YES` if a unit was assigned, `NO` if no unit was assigned
 */
- (BOOL)assignDefender:(BATAIInfluenceMap*)imap;

/**
 * Assigns a flanker to the "flank" ford target, then a CSA base.
 *
 * @return `YES` if a unit was assigned, `NO` if no unit was assigned
 */
- (BOOL)assignFlanker;

/** Placeholder. Probably obsolete. */
- (BOOL)reRoute;

@end
