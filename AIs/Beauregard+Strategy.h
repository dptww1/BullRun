//
//  Beauregard+Strategy.h
//  Bull Run
//
//  Created by Dave Townsend on 6/9/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import "Beauregard.h"

@class BAGame;

@interface Beauregard (Strategy)

- (void)strategize:(BAGame*)game;

- (BRAICSATheater)computeTheaterOf:(BAUnit*)unit;

- (void)conductStrategicMovement;

@end
