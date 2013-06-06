//
// BAGameObserving.h
//

#import "HMHex.h"

@class BABattleReport;
@class BAUnit;

/**
 * Protocol for objects which wish to be informed about game events.
 * All the methods here are optional.
 */
@protocol BAGameObserving <NSObject>

@optional

/**
 * Callback when a unit is sighted during movement.
 *
 * @param unit the unit which is now sighted
 */
- (void)unitNowSighted:(BAUnit*)unit;

/**
 * Callback when a unit is now no longer sighted during movement.
 *
 * @param unit the unit which is no longer sighted
 */
- (void)unitNowHidden:(BAUnit*)unit;

/**
 * Callback just before orders begin being processed.
 */
- (void)movePhaseWillBegin;

/**
 * Callback after all orders have been processed and the turn incremented.
 */
- (void)movePhaseDidEnd;

/**
 * Callback when a unit moves.
 *
 * @param unit the unit which is moving
 * @param hex the hex that the unit is moving to
 */
- (void)moveUnit:(BAUnit*)unit to:(HMHex)hex;

/**
 * Callback when an attack occurs.
 *
 * @param battleReport the specifics of the battle
 */
- (void)showAttack:(BABattleReport*)battleReport;

@end
