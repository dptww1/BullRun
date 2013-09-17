//
//  BattleAt.h
//
//  Created by Dave Townsend on 6/28/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

typedef enum { kBATPlayerSide1, kBATPlayerSide2 } BATPlayerSide;

#define OtherPlayer(SIDE) \
    ((SIDE) == kBATPlayerSide1 ? kBATPlayerSide2 : kBATPlayerSide1)


#define DEBUG_AI(fmt, ...)             //NSLog(fmt, ## __VA_ARGS__)
#define DEBUG_ANIMATION(fmt, ...)      //NSLog(fmt, ## __VA_ARGS__)
#define DEBUG_COMBAT(fmt, ...)         //NSLog(fmt, ## __VA_ARGS__)
#define DEBUG_MAP(fmt, ...)            //NSLog(fmt, ## __VA_ARGS__)
#define DEBUG_MODES(fmt, ...)          NSLog(fmt, ## __VA_ARGS__)
#define DEBUG_MOVEMENT(fmt, ...)       //NSLog(fmt, ## __VA_ARGS__)
#define DEBUG_MOVEORDERS(fmt, ...)     //NSLog(fmt, ## __VA_ARGS__)
#define DEBUG_REINFORCEMENTS(fmt, ...) //NSLog(fmt, ## __VA_ARGS__)
#define DEBUG_SIGHTING(fmt, ...)       //NSLog(fmt, ## __VA_ARGS__)


#import "BATAIDelegate.h"
#import "BATAIInfluenceMap.h"
#import "BATAIMoveTracker.h"
#import "BATBattleReport.h"
#import "BATGame.h"
#import "BATGameDelegate.h"
#import "BATGameObserving.h"
#import "BATMoveOrders.h"
#import "BATOrderOfBattle.h"
#import "BATReinforcementInfo.h"
#import "BATUnit.h"
