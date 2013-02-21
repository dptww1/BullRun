//
//  Game.h
//  Bull Run
//
//  Created by Dave Townsend on 1/10/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BAGameObserving.h"
#import "BAOrderOfBattle.h"
#import "BullRun.h"
#import "Game.h"
#import "HMMap.h"

@class Unit;

@interface Game : NSObject

@property                    PlayerSide       userSide;
@property (strong, readonly) HMMap*           board;
@property (strong, readonly) BAOrderOfBattle* oob;
@property (strong, readonly) NSMutableArray*  observers;

- (void)hackUserSide:(PlayerSide)newSide;

- (void)addObserver:(id<BAGameObserving>) observer;
- (void)doSighting:(PlayerSide)side;
- (void)doNextTurn;
- (Unit*)unitInHex:(HMHex)hex;

@end

// The single, publicly available global instance.
extern Game* game;

