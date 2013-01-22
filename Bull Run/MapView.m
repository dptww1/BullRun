//
//  MapView.m
//  Bull Run
//
//  Created by Dave Townsend on 1/15/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

#import <QuartzCore/QuartzCore.h>
#import "Board.h"
#import "Game.h"
#import "HexMapCoordinateTransformer.h"
#import "MapView.h"
#import "Unit.h"
#import "UnitView.h"

@implementation MapView

- (id)awakeAfterUsingCoder:(NSCoder *)decoder {
    self = [super awakeAfterUsingCoder:decoder];
    
    if (self) {
        // Orient the view to the same alignment as the map, which expects (0,0) in the upper left corner
        // rather than the lower left corner with rotated axes.
        [self setTransform:CGAffineTransformMakeRotation(DEGREES_TO_RADIANS(90.0))];
    }
    
    return self;
}

@end


