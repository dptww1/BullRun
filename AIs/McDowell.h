//
//  McDowell.h
//  Bull Run
//
//  Created by Dave Townsend on 5/8/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BAAIProtocol.h"
#import "BullRun.h"
#import "HMHex.h"

/** The possible types of roles which the strategy module might assign. */
typedef enum UnitRole {
    ROLE_ATTACK, /**< unit will advance on CSA base via the attack ford */
    ROLE_FLANK,  /**< unit will advance on CSA base via the flank ford */
    ROLE_DEFEND  /**< unit will respond to CSA advances */
} UnitRole;


/** USA AI */
@interface McDowell : NSObject <BAAIProtocol>

/** BAAIProtocol implementation. */
- (void)freeSetup:(BAGame*)game;

/** BAAIProtocol implementation. */
- (void)giveOrders:(BAGame*)game;

/**
 * The unit names which have already been assigned orders this turn.
 */
@property (nonatomic,strong) NSMutableSet* orderedThisTurn;

/** The ford which the attack force will work through. */
@property (nonatomic,assign) HMHex         attackFord;

/** The ford which the flanking force will use. */
@property (nonatomic,assign) HMHex         flankFord;

/** The USA game side. */
@property (nonatomic) PlayerSide side;

/**
 * The strategic role assigned to each USA unit.
 * key: (NSString)unitName
 * value: UnitRole enum value
 */
@property (nonatomic, strong) NSMutableDictionary* unitRoles;

@end
