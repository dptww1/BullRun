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
#import "BATAIInfluenceMap.h"
#import "BATGame.h"
#import "BATOrderOfBattle.h"
#import "BATUnit.h"
#import "BRMap.h"
#import "HXMGeometry.h"
#import "HXMHex.h"
#import "HXMMap.h"
#import "NSArray+DPTUtil.h"

@implementation McDowell (Private)

- (BATAIInfluenceMap*)createInfluenceMap:(BATGame*)game {
    BRMap* map = [BRMap map];
    NSArray* bases = [map basesForSide:[self side]];

    BATAIInfluenceMap* imap = [BATAIInfluenceMap mapFrom:map];

    NSArray* csaUnits = [[game oob] unitsForSide:OtherPlayer([self side])];
    [csaUnits enumerateObjectsUsingBlock:^(BATUnit* unit, NSUInteger idx, BOOL* stop){
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
        _unitRoles[@"Blenker"]    = @(BRAIUSAUnitRoleDefend);
        _unitRoles[@"Burnside"]   = @(BRAIUSAUnitRoleFlank);
        _unitRoles[@"Davies"]     = @(BRAIUSAUnitRoleDefend);
        _unitRoles[@"Franklin"]   = @(BRAIUSAUnitRoleFlank);
        _unitRoles[@"Howard"]     = @(BRAIUSAUnitRoleFlank);
        _unitRoles[@"Keyes"]      = @(BRAIUSAUnitRoleAttack);
        _unitRoles[@"Militia"]    = @(BRAIUSAUnitRoleDefend);
        _unitRoles[@"Porter"]     = @(BRAIUSAUnitRoleFlank);
        _unitRoles[@"Richardson"] = @(BRAIUSAUnitRoleDefend);
        _unitRoles[@"Schenck"]    = @(BRAIUSAUnitRoleAttack);
        _unitRoles[@"Sherman"]    = @(BRAIUSAUnitRoleAttack);
        _unitRoles[@"Volunteers"] = @(BRAIUSAUnitRoleDefend);
        _unitRoles[@"Willcox"]    = @(BRAIUSAUnitRoleFlank);

        _flankFord = HXMHexMake(3,2);
        _attackFord = HXMHexMake(6,4);
    }

    return self;
}

- (void)freeSetup:(BATGame*)game { }

- (void)giveOrders:(BATGame*)game {
    [_orderedThisTurn removeAllObjects];

    [self strategize:game];

    BATAIInfluenceMap* imap = [self createInfluenceMap:game];
    [imap dump];

    while ([self assignDefender:imap])
        ;

    while ([self assignAttacker])
        ;

    while ([self assignFlanker])
        ;
}

@end
