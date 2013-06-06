//
//  BAAGunfire.m
//  Bull Run
//
//  Created by Dave Townsend on 2/27/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import "BAAGunfire.h"
#import "UnitView.h"

@interface BAAGunfire ()

@property (nonatomic, strong) CAEmitterLayer* gun;

@end

@implementation BAAGunfire (Private)

+ (NSArray*)createEmittersWithAzimuth:(float)azimuth {
    CAEmitterCell* bullet = [CAEmitterCell emitterCell];
    [bullet setBirthRate:40.f];
    [bullet setLifetime:0.1f];
    [bullet setLifetimeRange:0.05f];
    [bullet setColor:[[UIColor blackColor] CGColor]];
    [bullet setName:@"bullet"];
    [bullet setContents:(id)[[UIImage imageNamed:@"bullet.png"] CGImage]];
    [bullet setVelocity:300.0f];
    [bullet setVelocityRange:0.0f];
    [bullet setEmissionLongitude:azimuth];

    return [NSArray arrayWithObject:bullet];
}

@end

@implementation BAAGunfire

+ (id)gunfireFrom:(UnitView *)unitView withAzimuth:(float)azimuth {
    return [[BAAGunfire alloc] initFrom:unitView withAzimuth:azimuth];
}

- (id)initFrom:(UnitView *)unitView withAzimuth:(float)azimuth {
    self = [super init];

    if (self) {
        _gun = [CAEmitterLayer layer];

        [_gun setEmitterPosition:CGPointMake(25.0f, 25.0f)]; // TODO: base on UnitView
        [_gun setEmitterSize:CGSizeMake(30.0f, 30.0f)]; // TODO: base on UnitView
        [_gun setEmitterCells:[BAAGunfire createEmittersWithAzimuth:azimuth]];
        [_gun setRenderMode:kCAEmitterLayerSurface];
        [_gun setEmitterShape:kCAEmitterLayerRectangle];

        [unitView addSublayer:_gun];
    }

    return self;
}

- (void)stop {
    [_gun setBirthRate:0.0f];
    [_gun removeFromSuperlayer];
}

@end
