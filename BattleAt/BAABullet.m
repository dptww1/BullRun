//
//  BAABullet.m
//  Bull Run
//
//  Created by Dave Townsend on 2/27/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import "BAABullet.h"

@implementation BAABullet

+ (id)bulletWithAzimuth:(float)azimuth {
    return [[BAABullet alloc] initWithAzimuth:azimuth];
}

- (id)initWithAzimuth:(float)azimuth {
    self = [CAEmitterCell emitterCell];

    if (self) {
        [self setBirthRate:40.f];
        [self setLifetime:0.1f];
        [self setLifetimeRange:0.05f];
        [self setColor:[[UIColor blackColor] CGColor]];
        [self setName:@"bullet"];
        [self setContents:(id)[[UIImage imageNamed:@"bullet.png"] CGImage]];
        [self setVelocity:300.0f];
        [self setVelocityRange:0.0f];
        [self setEmissionLongitude:azimuth];
    }

    return self;
}

@end
