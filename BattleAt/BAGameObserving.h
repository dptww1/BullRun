//
// GameObserving.h
//

#import "HMHex.h"

@class BABattleReport;
@class Unit;

@protocol BAGameObserving <NSObject>

@optional

- (void)unitNowSighted:(Unit*)unit;
- (void)unitNowHidden:(Unit*)unit;

- (void)movePhaseWillBegin;
- (void)movePhaseDidEnd;

- (void)moveUnit:(Unit*)unit to:(HMHex)hex;
- (void)showAttack:(BABattleReport*)battleReport;

@end
