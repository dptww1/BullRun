//
//  BAAIProtocol.h
//  Bull Run
//
//  Created by Dave Townsend on 5/8/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BAGame;

/**
 * Protocol which all AI classes should implement. I realize that protocols
 * are supposed to be named with a gerund ("...ing") form, but I couldn't
 * figure out how do that.  At least with "Protocol" in the name, users
 * shouldn't think it's a class.
 */
@protocol BAAIProtocol <NSObject>

/**
 * Called when the AI is required to supply a non-historical set up for the
 * game session.  Will be called only once, and might not get called at all
 * if the user wants to use the historical setup.
 *
 * @param game the game instance
 */
- (void)freeSetup:(BAGame*)game;

/**
 * Called at the beginning of each turn so the AI can give orders to its
 * units.  (Note that since the AI has access to the entire game structure,
 * nothing other than the AI programmer's honesty keeps the AI from giving
 * orders to enemy units.)
 *
 * @param game the game instance
 */
- (void)giveOrders:(BAGame*)game;

@end
