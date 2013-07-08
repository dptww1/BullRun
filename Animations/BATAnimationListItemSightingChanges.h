//
//  BATAnimationListItemSightingChanges.h
//
//  Created by Dave Townsend on 7/7/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import "BATAnimationListItem.h"

/**
 * Animation item showing a unit appearing to the user in its current location.
 */
@interface BATAnimationListItemSightingChanges : BATAnimationListItem

+ (id)itemSightingChangesWithNowSightedUnits:(NSSet*)sightedUnits
                           andNowHiddenUnits:(NSSet*)hiddenUnits;

@end
