//
// BATGameObserving.h
//

#import "HXMHex.h"

@class BATBattleReport;
@class BATUnit;

/**
 * Protocol for objects which wish to be informed about game events.
 * All the methods here are optional.
 */
@protocol BATGameObserving <NSObject>

@optional

/**
 * Callback when a unit is sighted during movement.
 *
 * @param unit the unit which is now sighted
 */
- (void)unitNowSighted:(BATUnit*)unit;

/**
 * Callback when a unit is now no longer sighted during movement.
 *
 * @param unit the unit which is no longer sighted
 */
- (void)unitNowHidden:(BATUnit*)unit;

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
- (void)moveUnit:(BATUnit*)unit to:(HXMHex)hex;

/**
 * Callback when an attack occurs.
 *
 * @param battleReport the specifics of the battle
 */
- (void)showAttack:(BATBattleReport*)battleReport;

@end
