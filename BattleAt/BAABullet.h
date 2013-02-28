//
//  BAABullet.h
//  Bull Run
//
//  Created by Dave Townsend on 2/27/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface BAABullet : CAEmitterCell

+ (id)bulletWithAzimuth:(float)azimuth;
- (id)initWithAzimuth:(float)azimuth;

@end
