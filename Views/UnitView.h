//
//  UnitView.h
//  Bull Run
//
//  Created by Dave Townsend on 1/16/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <Foundation/Foundation.h>


@class BATUnit;


/**
 * The screen representation of a unit.  Not really a "View" in the UIKit
 * sense of the word.  Maybe "UnitGfx" would be better?  (Or UnitGEL as a nod
 * to the Amiga....)
 *
 * This class has no designated initializers; you must use the class method
 * `viewForUnit:` to create instances.
 */
@interface UnitView : CALayer

/**
 * Gets the screen representation for the given unit, creating it if need be.
 * The results of this method are cached, and so subsequent calls will return
 * the same view (as opposed to creating a new view for the same unit).
 *
 * @param unit the unit to get the view for
 *
 * @return the unit's view
 */
+ (UnitView*)viewForUnit:(BATUnit*)unit;

/**
 * Finds the view for the given unit name. The view must have already been
 * created via `createForUnit:`.
 *
 * @param unitName the name of the unit to find the view for
 *
 * @return the unit's view, possibly `nil`
 *
 * @see createForUnit:
 */
+ (UnitView*)findByName:(NSString*)unitName;

@end
