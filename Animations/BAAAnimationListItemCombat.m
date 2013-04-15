//
//  BAAAnimationListItemCombat.m
//  Bull Run
//
//  Created by Dave Townsend on 4/9/13.
//  Copyright (c) 2013 Dave Townsend. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "BAAAnimationListItemCombat.h"
#import "BAAAnimationList.h"
#import "BAUnit.h"
#import "HMCoordinateTransformer.h"
#import "UnitView.h"

#define SECONDS_PER_HEX_MOVE 1.5f

static CGPoint shiftPoint(CGPoint pt, float dx, float dy) { // TODO: move to global location
    CGPoint p = pt;
    p.x += dx;
    p.y += dy;
    return p;
}

@implementation BAAAnimationListItemCombat

+ (id)itemWithAttacker:(BAUnit*)attacker defender:(BAUnit*)defender retreatTo:(HMHex)retreatHex advance:(BOOL)doAdvance {
    BAAAnimationListItemCombat* o = [[BAAAnimationListItemCombat alloc] init];

    if (o) {
        [o setAttacker:attacker];
        [o setDefender:defender];
        [o setRetreatHex:retreatHex];
        [o setAdvance:doAdvance];
    }

    return o;
}

- (void)runWithParent:(BAAAnimationList*)list {
    DEBUG_ANIMATION(@"running animation %@", self);

    HMCoordinateTransformer* xformer = [list xformer];

    [CATransaction begin];

    [CATransaction setCompletionBlock:^{
            [list run:nil];
        } ];

    // Attacker animation computation
    CGPoint centerPt = [xformer hexCenterToScreen:[[self attacker] location]];

    CAKeyframeAnimation* anim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    [anim setValues:@[
                      [NSValue valueWithCGPoint:centerPt],
                      [NSValue valueWithCGPoint:shiftPoint(centerPt, -5.0, 0)],
                      [NSValue valueWithCGPoint:centerPt],
                      [NSValue valueWithCGPoint:shiftPoint(centerPt, +5.0, 0)],
                      [NSValue valueWithCGPoint:centerPt]
                      ]
     ];
    [anim setDuration:SECONDS_PER_HEX_MOVE];  // TODO: apparently not working

    UnitView* v = [UnitView createForUnit:[self attacker]];
    [v addAnimation:anim forKey:[[self attacker] name]];
    //    [v setPosition:[xformer hexCenterToScreen:[self destination]]];

    [CATransaction commit];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"COMBAT attacker:%@ defender:%@ retreatHex:%02d%02d advance:%d",
            [[self attacker] name],
            [[self defender] name],
            [self retreatHex].column,
            [self retreatHex].row,
            [self advance]
            ];
}

@end
