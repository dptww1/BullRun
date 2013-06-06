//
//  Beauregard.h
//  Bull Run
//
//  Created by Dave Townsend on 5/8/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BAAIProtocol.h"

/** CSA AI */
@interface Beauregard : NSObject <BAAIProtocol>

/** BAAIProtocol implementation. */
- (void)freeSetup:(BAGame*)game;

/** BAAIProtocol implementation. */
- (void)giveOrders:(BAGame*)game;

@end
