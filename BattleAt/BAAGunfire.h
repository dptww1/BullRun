//
//  BAAGunfire.h
//  Bull Run
//
//  Created by Dave Townsend on 2/27/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@class UnitView;

@interface BAAGunfire : CAEmitterLayer

+ (id)gunfireFrom:(UnitView*)unitView withAzimuth:(float) azimuth;

@end
