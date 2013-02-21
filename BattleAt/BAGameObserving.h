//
// GameObserving.h
//

#import "HMHex.h"

@class BABattleReport;
@class BAUnit;

@protocol BAGameObserving <NSObject>

@optional

- (void)unitNowSighted:(BAUnit*)unit;
- (void)unitNowHidden:(BAUnit*)unit;

- (void)movePhaseWillBegin;
- (void)movePhaseDidEnd;

- (void)moveUnit:(BAUnit*)unit to:(HMHex)hex;
- (void)showAttack:(BABattleReport*)battleReport;

@end
