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
    if ([[BR1Map map] isHex:[enemy location] enemyOfPlayer:[enemy side]]) {
        DEBUG_SIGHTING(@"%@ is in enemy territory", [enemy name]);
        return YES;
    }

    // Innocent until proven guilty.
    __block BOOL sighted = NO;

    [friends enumerateObjectsUsingBlock:^(BATUnit* friend, NSUInteger idx, BOOL* stop) {
        HXMMap* map = [game board];

        // Friends which are offboard can't spot.
        if (![map isHexOnMap:[friend location]])
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
    // Turns begin at 6:30 AM, increment by 30 minutes per turn
    // Turn 1 => 6:30 AM
    // Turn 2 => 7:00 AM
    // Turn 3 => 7:30 AM
    // ...
    const char* amPm    = "AM";
    int         hour    = (turn / 2) + 6;
    int         minutes = turn & 1 ? 30 : 0;

    if (hour >= 12) {
        amPm = "PM";
        if (hour > 12)
            hour -= 12;
    }

    return [NSString stringWithFormat:@"%d:%02d %s",
            hour,
            minutes,
            amPm];
}

- (int)convertStringToTurn:(NSString*)string {
    NSCharacterSet* separators = [NSCharacterSet
                                  characterSetWithCharactersInString:@": "];
    NSArray* elts = [string componentsSeparatedByCharactersInSet:separators];

    if ([elts count] != 3)
        @throw [NSException
                exceptionWithName:@"IllegalTimeString"
                           reason:@"String missing (or too many) separators"
                         userInfo:nil];

    int hour = [elts[0] intValue];
    if ([elts[2] isEqualToString:@"PM"] && hour != 12)
        hour += 12;

    hour -= 6;
    int turn = hour * 2;

    // Minutes
    if ([elts[1] isEqualToString:@"30"])
        turn += 1;

    return turn;
}

@end
