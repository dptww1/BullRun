//
//  BullRun.h
//  Bull Run
//
//  Created by Dave Townsend on 1/5/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import "BattleAt.h"

#define CSA kBATPlayerSide1
#define USA kBATPlayerSide2

typedef enum {
    kBATModeCharge,
    kBATModeAttack,
    kBATModeSkirmish,
    kBATModeDefend,
    kBATModeWithdraw,
    kBATModeRouted
} BATMode;

#define NUM_MODES kBATModeRouted+1

#define IsOffensiveMode(mode) \
    ((mode) == kBATModeCharge || \
     (mode) == kBATModeAttack || \
     (mode) == kBATModeSkirmish)


