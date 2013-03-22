//
//  BAAGunfire.h
//  Bull Run
//
//  Created by Dave Townsend on 2/27/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@class UnitView;

// It would be nice to inherit from CAEmitterLayer, since this is a
// specialization of that class, but doing that apparently doesn't work.
@interface BAAGunfire : NSObject

@property (nonatomic, strong) CAEmitterLayer* gun;

+ (id)gunfireFrom:(UnitView*)unitView withAzimuth:(float) azimuth;

- (id)initFrom:(UnitView*)unitView withAzimuth:(float)azimuth;
- (void)stop;

@end
