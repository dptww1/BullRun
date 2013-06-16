//
//  Beauregard.m
//  Bull Run
//
//  Created by Dave Townsend on 5/8/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import "BAGame.h"
#import "BAUnit.h"
#import "Beauregard.h"
#import "Beauregard+Strategy.h"
#import "BullRun.h"

@implementation Beauregard (Private)

- (BRAICSARole)roleFromTheater:(BRAICSATheater)theater {
    return theater == BRAICSATheaterEast ? BRAICSATheaterEast
                                         : BRAICSATheaterWest;
}

@end


@implementation Beauregard

- (id)init {
    self = [super init];

    if (self) {
        _side = CSA;
        _unitRoles = [NSMutableDictionary dictionary];
        _orderedThisTurn = [NSMutableSet set];

        [[[game oob] unitsForSide:_side]
         enumerateObjectsUsingBlock:^(BAUnit* unit, NSUInteger idx, BOOL* stop) {
             if ([unit isOffMap]) {
                 DEBUG_AI(@"Initial Role for %@: None!", [unit name]);
                 _unitRoles[[unit name]] = @(BRAICSARoleNone);

             } else {
                 _unitRoles[[unit name]] = @([self computeTheaterOf:unit]);
                 DEBUG_AI(@"Initial Role for %@: %@!", [unit name], _unitRoles[[unit name]]);
             }
         }];
    }

    return self;
}

- (void)freeSetup:(BAGame*)game { }

- (void)giveOrders:(BAGame*)game {
    [_orderedThisTurn removeAllObjects];
    
    [self strategize:game];

    [self conductStrategicMovement];
}

- (HMHex)baseHexForTheater:(BRAICSATheater)theater {
    return theater == BRAICSATheaterEast ? HMHexMake(9, 12)
                                         : HMHexMake(4, 7);
}

@end
