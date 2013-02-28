//
//  BAAGunfire.m
//  Bull Run
//
//  Created by Dave Townsend on 2/27/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import "BAABullet.h"
#import "BAAGunfire.h"
#import "UnitView.h"

@implementation BAAGunfire

+ (id)gunfireFrom:(UnitView *)unitView withAzimuth:(float)azimuth {
    CAEmitterLayer* gf = [CAEmitterLayer layer];

    [gf setEmitterPosition:CGPointMake(25.0f, 25.0f)]; // TODO: base on UnitView
    [gf setEmitterSize:CGSizeMake(30.0f, 30.0f)]; // TODO: base on UnitView
    [gf setEmitterCells:[NSArray arrayWithObject:[BAABullet bulletWithAzimuth:azimuth]]];
    [gf setRenderMode:kCAEmitterLayerSurface];
    [gf setEmitterShape:kCAEmitterLayerRectangle];

    [unitView addSublayer:gf];

    return gf;
}

@end
