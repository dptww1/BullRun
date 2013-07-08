//
// BATGameObserving.h
//

#import "HexMap.h"

@class BATBattleReport;
@class BATUnit;

/**
 * Protocol for objects which wish to be informed about game events.
 * All the methods here are optional.
 */
@protocol BATGameObserving <NSObject>

@optional

/**
 * Callback after a unit moves and unit(s) now become hidden and/or sighted.
 *
 * @param sightedUnits collection of `BATUnit*` which are now sighted
 * @param hiddenUnits collection of `BATUnit*` which are now hidden
 */
- (void)sightingChangedWithNowSightedUnits:(NSSet*)sightedUnits
                         andNowHiddenUnits:(NSSet*)hiddenUnits;

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
