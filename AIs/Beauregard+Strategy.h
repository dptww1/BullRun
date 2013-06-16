//
//  Beauregard+Strategy.h
//  Bull Run
//
//  Created by Dave Townsend on 6/9/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import "Beauregard.h"


@class BAGame;
@class BAUnit;


@interface Beauregard (Strategy)

- (void)strategize:(BAGame*)game;

- (BRAICSATheater)computeTheaterOf:(BAUnit*)unit;

- (void)conductStrategicMovement;

- (void)routeUnit:(BAUnit*)unit toDestination:(HMHex)destination;

@end
