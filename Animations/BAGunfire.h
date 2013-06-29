//
//  BAGunfire.h
//
//  Created by Dave Townsend on 2/27/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@class UnitView;

/**
 * Encapsulates and controls the gunfire animation
 *
 * It would be nice to inherit from CAEmitterLayer, since this is a
 * specialization of that class, but doing that apparently doesn't work.
 */
@interface BAGunfire : NSObject

/**
 * Convenience class wrapper around designated initializer.
 * The azimuth angle begins with 0 degrees going due east.
 * 
 * @param unitView unit sprite to create gunfire for
 * @param azimuth angle of gunfire from `unitView` (0-359)
 * 
 * @return the initialized object; the gunfire animation will start immediately
 */
+ (id)gunfireFrom:(UnitView*)unitView withAzimuth:(float)azimuth;

/**
 * Designated initializer. The azimuth angle begins with 0 degrees going
 * due east.
 *
 * @param unitView unit sprite to create gunfire for
 * @param azimuth angle of gunfire from `unitView` (0-359)
 *
 * @return the initialized object; the gunfire animation will start immediately
 */
- (id)initFrom:(UnitView*)unitView withAzimuth:(float)azimuth;

/**
 * Stops the gunfire animation controlled by this object.
 */
- (void)stop;

@end
