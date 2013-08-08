//
//  BR1GameDelegate.m
//  Bull Run
//
//  Created by Dave Townsend on 8/8/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import "BR1GameDelegate.h"
#import "BR1Map.h"
#import "BattleAt.h"

@implementation BR1GameDelegate

#pragma mark - BATGameDelegate implementation


- (void)allotMovementPoints {
    for (BATUnit* u in [[game oob] units])
        [u setMps:[u mps] + 5];
}

- (BOOL)isUnit:(BATUnit*)enemy inHex:(HXMHex)hex sightedBy:(NSArray*)friends {
    // CSA north of river or USA south of river is always spotted (note that fords
    // are marked as on both sides of the river, so units on fords are always spotted).
    if ([[BR1Map map] isEnemy:[enemy location] of:[enemy side]]) {
        DEBUG_SIGHTING(@"%@ is in enemy territory", [enemy name]);
        return YES;
    }

    // Innocent until proven guilty.
    __block BOOL sighted = NO;

    [friends enumerateObjectsUsingBlock:^(BATUnit* friend, NSUInteger idx, BOOL* stop) {
        HXMMap* map = [game board];

        // Friends which are offboard can't spot.
        if (![map legal:[friend location]])
            return;

        BOOL friendInUsaZone = [map is:[friend location] inZone:@"usa"];
        BOOL friendInCsaZone = [map is:[friend location] inZone:@"csa"];

        // Friendly units within three hexes sight enemies...
        if ([map distanceFrom:[friend location] to:[enemy location]] < 4) {

            // ...as long as both units are on the same side of the river
            BOOL enemyInUsaZone = [map is:[enemy location] inZone:@"usa"];
            BOOL enemyInCsaZone = [map is:[enemy location] inZone:@"csa"];

            if ((friendInUsaZone && enemyInUsaZone) ||
                (friendInCsaZone && enemyInCsaZone)) {
                DEBUG_SIGHTING(@"%@ spots %@", [friend name], [enemy name]);
                *stop = sighted = YES;
            }
        }
    }];
    
    return sighted;
}

- (NSString*)convertTurnToString:(int)turn {
    return @"";
}

- (int)convertStringToTurn:(NSString*)string {
    return 0;
}

@end
