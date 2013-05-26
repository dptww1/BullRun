//
//  BRGame.m
//  Bull Run
//
//  Created by Dave Townsend on 5/10/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import "BAUnit.h"
#import "BRGame.h"
#import "BRMap.h"
#import "McDowell.h"

@implementation BRGame

- (id)init {
    self = [super init];

    if (self) {
        [self setAi:[[McDowell alloc] init]];
    }

    return self;
}

- (BRMap*)map {
    return (BRMap*)[self board];
}

// Returns YES if `enemy' situated in given terrain is sighted by any of `friends'.
- (BOOL)isUnit:(BAUnit*)enemy inHex:(HMHex)hex sightedBy:(NSArray*)friends {

    // CSA north of river or USA south of river is always spotted (note that fords
    // are marked as on both sides of the river, so units on fords are always spotted).
    if ([[self map] isEnemy:[enemy location] of:[enemy side]]) {
        DEBUG_SIGHTING(@"%@ is in enemy territory", [enemy name]);
        return YES;
    }

    // Innocent until proven guilty.
    __block BOOL sighted = NO;

    [friends enumerateObjectsUsingBlock:^(id friend, NSUInteger idx, BOOL* stop) {
        // Friends which are offboard can't spot.
        if (![[[self board] geometry] legal:[friend location]])
            return;

        // Friendly units within three hexes sight enemies...
        if ([[[self board] geometry] distanceFrom:[friend location] to:[enemy location]] < 4) {

            // ...as long as both units are on the same side of the river
            if ([self.board is:[friend location] inSameZoneAs:hex]) {
                DEBUG_SIGHTING(@"%@ spots %@", [friend name], [enemy name]);
                *stop = sighted = YES;
            }
        }
    }];

    return sighted;
}

@end
