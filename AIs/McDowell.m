//
//  McDowell.m
//  Bull Run
//
//  Created by Dave Townsend on 5/8/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import "McDowell.h"
#import "McDowell+Strategy.h"
#import "McDowell+Tactics.h"
#import "BAAIInfluenceMap.h"
#import "BAGame.h"
#import "BAUnit.h"
#import "BRMap.h"
#import "HMGeometry.h"
#import "HXMHex.h"
#import "HMMap.h"
#import "NSArray+DPTUtil.h"

@implementation McDowell (Private)

- (BAAIInfluenceMap*)createInfluenceMap:(BAGame*)game {
    BRMap* map = [BRMap map];
    NSArray* bases = [map basesForSide:[self side]];

    BAAIInfluenceMap* imap = [BAAIInfluenceMap mapFrom:map];

    NSArray* csaUnits = [[game oob] unitsForSide:OtherPlayer([self side])];
    [csaUnits enumerateObjectsUsingBlock:^(BAUnit* unit, NSUInteger idx, BOOL* stop){
        __block HXMHex location = [unit location];

        // Is unit on map, north of river, and not on a ford?
        if (![unit isOffMap] && [map is:location inZone:@"usa"] && ![map is:location inZone:@"csa"]) {
            [bases enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                HXMHex base;
                [obj getValue:&base];

                int dist = [map distanceFrom:location to:base];
                if (dist > 10)
                    dist = 10;

                int dir = [map directionFrom:location to:base];

                float value = (float)(1 << (10 - dist));

                // Plant values in each hex adjacent to the unit's location
                for (int i = 0; i < 6; ++i) {
                    HXMHex curHex = [map hexAdjacentTo:location inDirection:i];
                    float curValue = value;

                    // Beware of moving offmap, or into CSA territory
                    if (![map legal:curHex] || [map is:curHex inZone:@"csa"])
                        continue;

                    // Reduce the value by half if it's not directly towards the base
                    if (i != dir) {
                        curValue /= 2.0;

                        // If it's not a direction towards the base, halve it again
                        if (i != [map rotateDirection:dir clockwise:YES] &&
                            i != [map rotateDirection:dir clockwise:NO])
                            curValue /= 2.0;
                    }

                    if ([imap valueAt:curHex] < curValue)
                        [imap setValue:[imap valueAt:curHex] / 2.0 + curValue atHex:curHex];
                    else
                        [imap addValue:1.0f atHex:curHex];
                }
            }];
        }
    }];

    return imap;
}

@end

@implementation McDowell

- (id)init {
    self = [super init];
    
    if (self) {
        _side = USA;

        _orderedThisTurn = [NSMutableSet set];
        _unitRoles = [NSMutableDictionary dictionary];
        
        // Set the data for the historical setup.
        _unitRoles[@"Blenker"]    = @(ROLE_DEFEND);
        _unitRoles[@"Burnside"]   = @(ROLE_FLANK);
        _unitRoles[@"Davies"]     = @(ROLE_DEFEND);
        _unitRoles[@"Franklin"]   = @(ROLE_FLANK);
        _unitRoles[@"Howard"]     = @(ROLE_FLANK);
        _unitRoles[@"Keyes"]      = @(ROLE_ATTACK);
        _unitRoles[@"Militia"]    = @(ROLE_DEFEND);
        _unitRoles[@"Porter"]     = @(ROLE_FLANK);
        _unitRoles[@"Richardson"] = @(ROLE_DEFEND);
        _unitRoles[@"Schenck"]    = @(ROLE_ATTACK);
        _unitRoles[@"Sherman"]    = @(ROLE_ATTACK);
        _unitRoles[@"Volunteers"] = @(ROLE_DEFEND);
        _unitRoles[@"Willcox"]    = @(ROLE_FLANK);

        _flankFord = HXMHexMake(3,2);
        _attackFord = HXMHexMake(6,4);
    }

    return self;
}

- (void)freeSetup:(BAGame*)game { }

- (void)giveOrders:(BAGame*)game {
    [_orderedThisTurn removeAllObjects];

    [self strategize:game];

    BAAIInfluenceMap* imap = [self createInfluenceMap:game];
    [imap dump];

    while ([self assignDefender:imap])
        ;

    while ([self assignAttacker])
        ;

    while ([self assignFlanker])
        ;
}

@end
