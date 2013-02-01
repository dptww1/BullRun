//
//  Terrain.h
//  Bull Run
//
//  Created by Dave Townsend on 1/12/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BullRun.h"

// Bull Run specific
@interface Terrain : NSObject

- (id)initWithInt:(int)rawValue;

// Does the terrain represent CSA territory?
- (BOOL)isCsa;

// Does the terrain represent USA territory?
- (BOOL)isUsa;

// Does the terrain represent territory that's owned by the enemy of `side'?
- (BOOL)isEnemy:(PlayerSide)side;

- (BOOL)onSameSideOfRiver:(Terrain*)otherTerrain;

// # of MPs to enter this terrain
- (int)mpCost;

@end
