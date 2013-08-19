//
//  Beauregard+Strategy.h
//  Bull Run
//
//  Created by Dave Townsend on 6/9/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import "Beauregard.h"


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
- (BRAICSATheater)computeTheaterOf:(BATUnit*)unit;

/**
 * Orders units which are located in one theater but strategically
 * allocated to the other theater.
 */
- (void)conductStrategicMovement;

@end
