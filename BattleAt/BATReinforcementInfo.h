//
//  BATReinforcementInfo.h
//
//  Created by Dave Townsend on 2/20/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HXMHex.h"

@class BAUnit;

/** Contains the location/turn information needed for a single reinforcement. */
@interface BATReinforcementInfo : NSObject <NSCoding>

/** The name of the reinforcing unit. */
@property (nonatomic, readonly, copy) NSString* unitName;

/** Where the reinforcement appears. */
@property (nonatomic, assign)         HXMHex    entryLocation;

/** When the reinforcement appears. */
@property (nonatomic, assign)         int       entryTurn;

/**
 * Convenience class method.  The reinforcement turn in slurped from
 * `[unit turn]`, and the reinforcement hex from `[unit location]`.
 *
 * @param unit the reinforcing unit
 *
 * @return the new reinforcement object
 */
+ (BATReinforcementInfo*)createWithUnit:(BAUnit*)unit;

/**
 * Designated initializer.
 *
 * @param unit the reinforcing unit
 * @param turn turn of entry
 * @param hex location of reinforcement
 *
 * @return the new reinforcement object
 */
- (BATReinforcementInfo*)initWithUnit:(BAUnit*)unit
                               onTurn:(int)turn
                                atHex:(HXMHex)hex;

@end
