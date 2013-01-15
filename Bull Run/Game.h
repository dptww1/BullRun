//
//  Game.h
//  Bull Run
//
//  Created by Dave Townsend on 1/10/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Board.h"
#import "BullRun.h"
#import "Game.h"
#import "OrderOfBattle.h"

@interface Game : NSObject

@property                    PlayerSide     userSide;
@property (strong, readonly) Board*         board;
@property (strong, readonly) OrderOfBattle* oob;

- (void)hackUserSide:(PlayerSide)newSide;

@end

// The single, publicly available global instance.
extern Game* game;

