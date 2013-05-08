//
//  Beauregard.h
//  Bull Run
//
//  Created by Dave Townsend on 5/8/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BAAIProtocol.h"

@interface Beauregard : NSObject <BAAIProtocol>

- (void)freeSetup:(BAGame*)game;
- (void)giveOrders:(BAGame*)game;

@end
