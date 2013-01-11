//
//  Game.m
//  Bull Run
//
//  Created by Dave Townsend on 1/10/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import "Game.h"
#import "BullRun.h"
#import "OrderOfBattle.h"

Game* game;

@interface Game (Private)

- (void)doSighting:(PlayerSide)side;

@end

@implementation Game

#pragma mark - Init Methods

- (id)init {
    self = [super init];
    
    if (self) {
        _userSide = CSA;
        _board = [[Board alloc] init];
        _oob = [OrderOfBattle createFromFile:[[NSBundle mainBundle] pathForResource:@"units" ofType:@"plist"]];
    }

    return self;
}

#pragma mark - Private Methods

// Performs sighting from the POV of player `side'. In practice will
// most usually be called with side parameter == userSide attribute,
// but doing it this way allows more convenient testing and debugging.
- (void)doSighting:(PlayerSide)side {

}

@end
