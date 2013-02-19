//
//  BABattleReport.m
//  Bull Run
//
//  Created by Dave Townsend on 2/18/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import "BABattleReport.h"

@implementation BABattleReport

+ (id)battleReportWithAttacker:(Unit *)attacker andDefender:(Unit *)defender {
    return [[BABattleReport alloc] initWithAttacker:attacker
                                        andDefender:defender];
}

- (id)initWithAttacker:(Unit *)attacker andDefender:(Unit *)defender {
    self = [super init];

    if (self) {
        _attacker           = attacker;
        _defender           = defender;
        _attackerCasualties = 0;
        _defenderCasualties = 0;
        _retreatHex         = HexMake(-1, -1);
        _advanceHex         = HexMake(-1, -1);
    }

    return self;
}

@end
