//
//  BATBattleReport.m
//
//  Created by Dave Townsend on 2/18/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import "BATBattleReport.h"

@implementation BATBattleReport

+ (id)battleReportWithAttacker:(BAUnit*)attacker andDefender:(BAUnit*)defender {
    return [[BATBattleReport alloc] initWithAttacker:attacker
                                         andDefender:defender];
}

- (id)initWithAttacker:(BAUnit*)attacker andDefender:(BAUnit*)defender {
    self = [super init];

    if (self) {
        _attacker           = attacker;
        _defender           = defender;
        _attackerCasualties = 0;
        _defenderCasualties = 0;
        _retreatHex         = HXMHexMake(-1, -1);
        _advanceHex         = HXMHexMake(-1, -1);
    }

    return self;
}

@end