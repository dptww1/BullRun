//
//  McDowell.h
//  Bull Run
//
//  Created by Dave Townsend on 5/8/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BAAIProtocol.h"

/** USA AI */
@interface McDowell : NSObject <BAAIProtocol>

/** BAAIProtocol implementation. */
- (void)freeSetup:(BAGame*)game;

/** BAAIProtocol implementation. */
- (void)giveOrders:(BAGame*)game;

@end

/**
 * McDowell's private properties.
 */
@interface McDowell ()

/**
 * Contains names of units which have already been assigned orders this turn.
 */
@property (nonatomic,strong) NSMutableSet* orderedThisTurn;

@end
