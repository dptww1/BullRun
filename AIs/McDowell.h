//
//  McDowell.h
//  Bull Run
//
//  Created by Dave Townsend on 5/8/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BAAIProtocol.h"

@interface McDowell : NSObject <BAAIProtocol>

- (void)freeSetup:(BAGame*)game;
- (void)giveOrders:(BAGame*)game;

@end
