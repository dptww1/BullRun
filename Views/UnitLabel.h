//
//  UnitLabel.h
//
//  Created by Dave Townsend on 8/29/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>


@class BATUnit;


/**
 * Encapsulate the graphics contents of a unit's name label.
 *
 * This class has no designated initializers; you must use the
 * class method `labelForUnit:` to create instances.
 */
@interface UnitLabel : CATextLayer

/**
 * Class constructor.
 *
 * @param unit the unit to create the label for
 *
 * @return the created instance
 */
+ (UnitLabel*)labelForUnit:(BATUnit*)unit;

@end
