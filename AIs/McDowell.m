//
//  McDowell.m
//  Bull Run
//
//  Created by Dave Townsend on 5/8/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import "McDowell.h"
#import "BAGame.h"
#import "BAUnit.h"
#import "CollectionUtil.h"

#define DO_SANITY_CHECK 1

enum UnitRole {
    ROLE_ATTACK,
    ROLE_FLANK,
    ROLE_DEFEND
};

@interface McDowell ()

@property (nonatomic) PlayerSide side;

// key: (NSString)unitName  value: UnitRole enum value
@property (nonatomic, strong) NSMutableDictionary* unitRoles;

@end

@implementation McDowell (Private)

#ifdef DO_SANITY_CHECK
- (void)checkSanity:(BAGame*)game {
    NSArray* units = [[game oob] unitsForSide:[self side]];
    if ([units count] != [[self unitRoles] count])
        DEBUG_AI(@"# USA units = %d but # units assigned to roles = %d",
                 [units count], [[self unitRoles] count]);

    [units enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        BAUnit* unit = obj;
        if (![[self unitRoles] objectForKey:[unit name]])
            DEBUG_AI(@"Unit %@ has no roles entry", [unit name]);
    }];

    // Because the collection sizes are the same, we don't also need to check
    // back from 'unitRoles' to 'units'.
}
#endif

- (CUFilter)isCsaUnitAttacking {
    return ^BOOL(BAUnit* unit) {
        HMHex hex = [unit location];
        return [unit sighted]
            && [[game board] is:hex inZone:@"usa"]
            && ![[game board] is:hex inZone:@"csa"];
    };
}


- (int)countCsaAttacking:(BAGame*)game {
    NSArray* units = [[game oob] unitsForSide:OtherPlayer([self side])];
    return [[units grep:[self isCsaUnitAttacking]] count];
}

- (CUFilter)isUsaUnitDefending {
    return ^BOOL(BAUnit* unit) {
        NSNumber* role = [[self unitRoles] objectForKey:[unit name]];
        return role
            && [role isEqualToNumber:[NSNumber numberWithInt:ROLE_DEFEND]]
            && ![unit isOffMap];
    };
}

- (int)countUsaDefending:(BAGame*)game {
    return [[[[game oob] unitsForSide:[self side]]
             grep:[self isUsaUnitDefending]] count];
}

- (void)changeOneDefenderToAttacker {
    // Find the defending unit nearest a ford

#if 0
    BAUnit* minUnit = nil;  // current closest unit
    int     minDist = 1000; // current closest distance

    NSArray* usaUnits = [[game oob] unitsForSide:[self side]];
    [usaUnits enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL* stop) {
        BAUnit* curUnit = obj;
        // TODO: calculate closest fod
        }];
#endif
}

- (void)convertNonDefenderToDefender { // TODO:

}

@end

@implementation McDowell

- (id)init {
    if (self) {
        _side = USA;

        _unitRoles = [NSMutableDictionary dictionary];
        [_unitRoles setObject:[NSNumber numberWithInt:ROLE_DEFEND] forKey:@"Blenker"];
        [_unitRoles setObject:[NSNumber numberWithInt:ROLE_FLANK]  forKey:@"Burnside"];
        [_unitRoles setObject:[NSNumber numberWithInt:ROLE_DEFEND] forKey:@"Davies"];
        [_unitRoles setObject:[NSNumber numberWithInt:ROLE_FLANK]  forKey:@"Franklin"];
        [_unitRoles setObject:[NSNumber numberWithInt:ROLE_FLANK]  forKey:@"Howard"];
        [_unitRoles setObject:[NSNumber numberWithInt:ROLE_ATTACK] forKey:@"Keyes"];
        [_unitRoles setObject:[NSNumber numberWithInt:ROLE_DEFEND] forKey:@"Militia"];
        [_unitRoles setObject:[NSNumber numberWithInt:ROLE_FLANK]  forKey:@"Porter"];
        [_unitRoles setObject:[NSNumber numberWithInt:ROLE_DEFEND] forKey:@"Richardson"];
        [_unitRoles setObject:[NSNumber numberWithInt:ROLE_ATTACK] forKey:@"Schenck"];
        [_unitRoles setObject:[NSNumber numberWithInt:ROLE_ATTACK] forKey:@"Sherman"];
        [_unitRoles setObject:[NSNumber numberWithInt:ROLE_DEFEND] forKey:@"Volunteers"];
        [_unitRoles setObject:[NSNumber numberWithInt:ROLE_FLANK]  forKey:@"Willcox"];
    }

    return self;
}

- (void)freeSetup:(BAGame*)game { }

- (void)giveOrders:(BAGame*)game {

#ifdef DO_SANITY_CHECK
    [self checkSanity:game];
#endif

    int numCsaAttacking = [self countCsaAttacking:game];
    int numUsaDefending = [self countUsaDefending:game];
    DEBUG_AI(@"Strategic situation: %d CSA attackers vs %d USA defenders",
             numCsaAttacking,
             numUsaDefending);

    int surplus = numUsaDefending - numCsaAttacking;

    if (surplus > 0)
        for (int i = 0; i < surplus; ++i)
            [self changeOneDefenderToAttacker];

    else if (surplus < 0)
        for (int i = 0; i < -surplus; ++i)
            [self convertNonDefenderToDefender];
}

@end