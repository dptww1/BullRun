//
//  McDowell+Strategy.h
//  Bull Run
//
//  Created by Dave Townsend on 5/22/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BAAIProtocol.h"
#import "McDowell.h"
#import "NSArray+DPTUtil.h"


/** USA AI Strategic thinking. */
@interface McDowell (Strategy)

/** 
 * Do strategic thinking to determine the broad roles units should take
 * for this turn.
 *
 * @param game the current game situation
 */
- (void)strategize:(BAGame*)game;

/**
 * Returns a block which evaluates whether or not a given USA unit is defending.
 *
 * @return the block
 */
- (DPTUtilFilter)isUsaUnitDefending;

@end