//
//  BAAAnimationListItemCombat.h
//  Bull Run
//
//  Created by Dave Townsend on 4/9/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BAAAnimationListItem.h"
#import "HXMHex.h"

@class BATUnit;
@class BAAAnimationList;
@class BAAGunfire;

/** Animation item showing combat, with optional retreat and advance. */
@interface BAAAnimationListItemCombat : BAAAnimationListItem

/**
 * Designated class initializer.
 *
 * @param attacker the attacking unit
 * @param defender the defending unit
 * @param retreatHex the retreat hex, or (-1,-1) if none
 * @param advanceHex the advance hex, or (-1,-1) if none
 */
+ (id)itemWithAttacker:(BATUnit*)attacker
              defender:(BATUnit*)defender
             retreatTo:(HXMHex)retreatHex
             advanceTo:(HXMHex)advanceHex;

@end
