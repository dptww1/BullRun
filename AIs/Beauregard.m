//
//  Beauregard.m
//  Bull Run
//
//  Created by Dave Townsend on 5/8/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import "BATAIInfluenceMap.h"
#import "BAGame.h"
#import "BAUnit.h"
#import "Beauregard.h"
#import "Beauregard+Strategy.h"
#import "Beauregard+Tactics.h"
#import "BullRun.h"
#import "BRMap.h"
#import "NSArray+DPTUtil.h"


@implementation Beauregard (Private)

- (BATAIInfluenceMap*)createInfluenceMap:(BAGame*)game {
    BRMap* map = [BRMap map];
    BATAIInfluenceMap* imap = [BATAIInfluenceMap mapFrom:map];

    NSArray* usaUnits = [[game oob] unitsForSide:OtherPlayer([self side])];
    [usaUnits enumerateObjectsUsingBlock:^(BAUnit* unit, NSUInteger idx, BOOL* stop) {
        if ([unit isOffMap] || ![unit sighted])
            return;

        HXMHex location = [unit location];
        BRAICSATheater theater = [self computeTheaterOf:unit];
        HXMHex baseHex = [self baseHexForTheater:theater];

        int dist = [map distanceFrom:location to:baseHex];
        if (dist > 10)
            dist = 10;

        int dir = [map directionFrom:location to:baseHex];

        float value = (float)(1 << (10 - dist));

        for (int i = 0; i < 6; ++i) {
            HXMHex curHex = [map hexAdjacentTo:location inDirection:i];
            float curValue = value;

            if (![map legal:curHex])
                continue;

            // Double value in CSA territory
            if ([map is:curHex inZone:@"csa"])
                curValue *= 2.0f;

            if (i != dir) {
                curValue /= 2.0f;

                if (i != [map rotateDirection:dir clockwise:YES] &&
                    i != [map rotateDirection:dir clockwise:NO])
                    curValue /= 2.0f;
            }

            if ([imap valueAt:curHex] < curValue)
                [imap setValue:[imap valueAt:curHex] / 2.0f + curValue atHex:curHex];
            else
                [imap addValue:1.0f atHex:curHex];
        }
    }];

    return imap;
}

- (BRAICSARole)roleFromTheater:(BRAICSATheater)theater {
    return theater == BRAICSATheaterEast ? BRAICSATheaterEast
                                         : BRAICSATheaterWest;
}

@end


@implementation Beauregard

- (id)init {
    self = [super init];

    if (self) {
        _side = CSA;
        _unitRoles = [NSMutableDictionary dictionary];
        _orderedThisTurn = [NSMutableSet set];

        [[[game oob] unitsForSide:_side]
         enumerateObjectsUsingBlock:^(BAUnit* unit, NSUInteger idx, BOOL* stop) {
             if ([unit isOffMap]) {
                 DEBUG_AI(@"Initial Role for %@: None!", [unit name]);
                 _unitRoles[[unit name]] = @(BRAICSARoleNone);

             } else {
                 _unitRoles[[unit name]] = @([self computeTheaterOf:unit]);
                 DEBUG_AI(@"Initial Role for %@: %@!", [unit name], _unitRoles[[unit name]]);
             }
         }];
    }

    return self;
}

- (void)freeSetup:(BAGame*)game { }

- (void)giveOrders:(BAGame*)game {
    [_orderedThisTurn removeAllObjects];
    
    [self strategize:game];

    BATAIInfluenceMap* imap = [self createInfluenceMap:game];

    [self conductStrategicMovement];

    while ([self assignDefender:imap])
        ;

    while ([self assignAttacker])
        ;
}

- (HXMHex)baseHexForTheater:(BRAICSATheater)theater {
    return theater == BRAICSATheaterEast ? HXMHexMake(9, 12)
                                         : HXMHexMake(4, 7);
}

- (NSArray*)unorderedCsaUnits {
    return [[[game oob] unitsForSide:_side] dpt_grep:^BOOL(BAUnit* unit) {
        return ![unit isOffMap]
            && ![_orderedThisTurn containsObject:[unit name]];
    }];
}

@end
