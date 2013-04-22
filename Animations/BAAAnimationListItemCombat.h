//
//  BAAAnimationListItemCombat.h
//  Bull Run
//
//  Created by Dave Townsend on 4/9/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BAAAnimationListItem.h"
#import "HMHex.h"

@class BAUnit;
@class BAAAnimationList;
@class BAAGunfire;

@interface BAAAnimationListItemCombat : BAAAnimationListItem

+ (id)itemWithAttacker:(BAUnit*)attacker
              defender:(BAUnit*)defender
             retreatTo:(HMHex)retreatHex
             advanceTo:(HMHex)advanceHex;

- (void)runWithParent:(BAAAnimationList*)list;

@end
