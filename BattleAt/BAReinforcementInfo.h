//
//  BAReinforcementInfo.h
//  Bull Run
//
//  Created by Dave Townsend on 2/20/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HMHex.h"

@class BAUnit;

/** Contains the location/turn information needed for a single reinforcement. */
@interface BAReinforcementInfo : NSObject <NSCoding>

/** The name of the reinforcing unit. */
@property (nonatomic, readonly, copy) NSString* unitName;

/** Where the reinforcement appears. */
@property (nonatomic, assign)         HMHex     entryLocation;

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
+ (BAReinforcementInfo*)createWithUnit:(BAUnit*)unit;

/**
 * Designated initializer.
 *
 * @param unit the reinforcing unit
 * @param turn turn of entry
 * @param hex location of reinforcement
 *
 * @return the new reinforcement object
 */
- (BAReinforcementInfo*)initWithUnit:(BAUnit*)unit
                              onTurn:(int)turn
                               atHex:(HMHex)hex;

@end
