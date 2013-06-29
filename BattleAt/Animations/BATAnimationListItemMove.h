//
//  BATAnimationListItemMove.h
//
//  Created by Dave Townsend on 4/8/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BATAnimationListItem.h"
#import "HXMHex.h"

@class BATUnit;
@class BATAnimationList;

/**
 * Animation item showing a unit moving from its current location
 * to a new hex.
 */
@interface BATAnimationListItemMove : BATAnimationListItem

/**
 * Designated class initializer.
 *
 * @param unit the moving unit
 * @param hex the unit's movement destination
 *
 * @return the initialized animation item
 */
+ (id)itemMoving:(BATUnit*)unit toHex:(HXMHex)hex;

@end
