//
// BAGameObserving.h
//

#import "HMHex.h"

@class BABattleReport;
@class BAUnit;

@protocol BAGameObserving <NSObject>

@optional

- (void)unitNowSighted:(BAUnit*)unit;
- (void)unitNowHidden:(BAUnit*)unit;

// Called before any orders are processed.
- (void)movePhaseWillBegin;

// Called after all orders have been processed and turn has been incremented.
- (void)movePhaseDidEnd;

- (void)moveUnit:(BAUnit*)unit to:(HMHex)hex;
- (void)showAttack:(BABattleReport*)battleReport;

@end
