//
//  BATAnimationListItemSightingChanges.h
//
//  Created by Dave Townsend on 7/7/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import "BATAnimationListItem.h"

/**
 * Animation item showing sighting changes caused by a unit moving
 * from one hex to another.
 */
@interface BATAnimationListItemSightingChanges : BATAnimationListItem

/**
 * Convenience constructor.
 *
 * @param sightedUnits set of `BATUnit*` units now sighted
 * @param hiddenUnits set of `BATUnit*` units now hidden
 *
 * @return an initialized instance
 */
+ (id)itemSightingChangesWithNowSightedUnits:(NSSet*)sightedUnits
                           andNowHiddenUnits:(NSSet*)hiddenUnits;

@end
