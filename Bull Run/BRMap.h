//
//  BRMap.h
//  Bull Run
//
//  Created by Dave Townsend on 5/10/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import "HMMap.h"
#import "BullRun.h"

@interface BRMap : HMMap

// Retrieves the single global instance
+ (BRMap*)map;

- (BOOL)isEnemy:(HMHex)hex of:(PlayerSide)side;
- (HMHexAndDistance)closestFordTo:(HMHex)hex;

// Returns array of NSValue-encoded HMHexes
- (NSArray*)basesForSide:(PlayerSide)side;

@end
