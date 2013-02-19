//
//  Game.h
//  Bull Run
//
//  Created by Dave Townsend on 1/10/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BAGameObserving.h"
#import "BullRun.h"
#import "Game.h"
#import "HMMap.h"
#import "OrderOfBattle.h"

@interface Game : NSObject

@property                    PlayerSide      userSide;
@property (strong, readonly) HMMap*          board;
@property (strong, readonly) OrderOfBattle*  oob;
@property (strong, readonly) NSMutableArray* observers;

- (void)hackUserSide:(PlayerSide)newSide;

- (void)addObserver:(id<BAGameObserving>) observer;
- (void)doSighting:(PlayerSide)side;
- (void)doNextTurn;

@end

// The single, publicly available global instance.
extern Game* game;

