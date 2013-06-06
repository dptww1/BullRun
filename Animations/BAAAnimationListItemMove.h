//
//  BAAAnimationListItemMove.h
//  Bull Run
//
//  Created by Dave Townsend on 4/8/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BAAAnimationListItem.h"
#import "HMHex.h"

@class BAUnit;
@class BAAAnimationList;

/**
 * Animation item showing a unit moving from its current location
 * to a new hex.
 */
@interface BAAAnimationListItemMove : BAAAnimationListItem

/**
 * Designated class initializer.
 *
 * @param unit the moving unit
 * @param hex the unit's movement destination
 *
 * @return the initialized animation item
 */
+ (id)itemMoving:(BAUnit*)unit toHex:(HMHex)hex;

@end
