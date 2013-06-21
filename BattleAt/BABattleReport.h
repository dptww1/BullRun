//
//  BABattleReport.h
//  Bull Run
//
//  Created by Dave Townsend on 2/18/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HXMHex.h"

@class BAUnit;

/**
 * Encapsulates all the information relevant to single attack.
 * If the HMHex parameters are not legal, then no retreat or advance
 * takes place.
 *
 * It's basically immutable, but most of the parameters are read-write
 * to keep the number of parameters in the initializers down.
 */
@interface BABattleReport : NSObject

/** The attacking unit. */
@property (nonatomic, strong, readonly) BAUnit* attacker;

/** The defending unit. */
@property (nonatomic, strong, readonly) BAUnit* defender;

/** The number of casualties taken by the attacker. */
@property (nonatomic, assign)           int     attackerCasualties;

/** The number of casualties taken by the defender. */
@property (nonatomic, assign)           int     defenderCasualties;

/** The hex the defender is retreating to; (-1,-1) means no retreat. */
@property (nonatomic, assign)           HXMHex  retreatHex;

/** The hex the attacker is advancing into; (-1,-1) means no advance. */
@property (nonatomic, assign)           HXMHex  advanceHex;

/**
 * Convenience static initializer.
 *
 * @param attacker the attacking unit
 * @param defender the defending unit
 *
 * @return the initialized object
 */
+ (id)battleReportWithAttacker:(BAUnit*)attacker andDefender:(BAUnit*)defender;

/**
 * Designated initializer.
 *
 * @param attacker the attacking unit
 * @param defender the defending unit
 *
 * @return the initialized object
 */
- (id)initWithAttacker:(BAUnit*)attacker andDefender:(BAUnit*)defender;

@end
