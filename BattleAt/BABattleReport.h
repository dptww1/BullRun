//
//  BABattleReport.h
//  Bull Run
//
//  Created by Dave Townsend on 2/18/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HMHex.h"

@class Unit;

/**
 * Encapsulates all the information relevant to single attack.
 * If the HMHex parameters are not legal, then no retreat or advance
 * takes place.
 */
@interface BABattleReport : NSObject

@property (strong, nonatomic, readonly) Unit* attacker;
@property (strong, nonatomic, readonly) Unit* defender;
@property                               int   attackerCasualties;
@property                               int   defenderCasualties;
@property                               HMHex retreatHex;
@property                               HMHex advanceHex;

+ (id)battleReportWithAttacker:(Unit*)attacker andDefender:(Unit*)defender;

- (id)initWithAttacker:(Unit*)attacker andDefender:(Unit*)defender;

@end
