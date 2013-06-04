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
#import "BAAGunfire.h"
#import "BAGame.h"
#import "BAUnit.h"
#import "DPTSysUtil.h"
#import "HMCoordinateTransformer.h"
#import "UnitView.h"

static CGPoint shiftPoint(CGPoint pt, float dx, float dy) { // TODO: move to global location
    CGPoint p = pt;
    p.x += dx;
    p.y += dy;
    return p;
}

//==============================================================================
@interface BAAAnimationListItemCombat ()

// Copies of class init method parameters
@property (nonatomic, strong) BAUnit*     attacker;
@property (nonatomic, strong) BAUnit*     defender;
@property (nonatomic)         HMHex       retreatHex;
@property (nonatomic)         HMHex       advanceHex;

// Convenience parameters
@property (nonatomic, strong) BAAGunfire* attackerGunfire;
@property (nonatomic)         HMHex       attackerHex;
@property (nonatomic)         HMHex       defenderHex;

@end

//==============================================================================
@implementation BAAAnimationListItemCombat (Private)

- (void)showRetreatAndAdvance:(BAAAnimationList*)list {
    DEBUG_ANIMATION(@"running animation %@ (advance/retreat)", self);
    
    [[self attackerGunfire] stop];
    [self setAttackerGunfire:nil];

    if ([[game board] legal:[self retreatHex]]) {
        [CATransaction begin];

        [CATransaction setAnimationDuration:SECONDS_PER_HEX_MOVE];
        [CATransaction setCompletionBlock:^{
                [self endCombat:list];
            } ];

        HMCoordinateTransformer* xformer = [list xformer];

        CAAnimation* dAnim = [self createMoveAnimationFor:[self defender]
                                               movingFrom:[self defenderHex]
                                                       to:[self retreatHex]
                                               usingXform:xformer];

        UnitView* dv = [UnitView createForUnit:[self defender]];
        [dv setPosition:[xformer hexCenterToScreen:[self retreatHex]]];
        [dv addAnimation:dAnim forKey:@"position"];

        if ([[game board] legal:[self advanceHex]]) {
            CAAnimation* aAnim = [self createMoveAnimationFor:[self attacker]
                                                   movingFrom:[self attackerHex]
                                                           to:[self defenderHex]
                                                   usingXform:xformer];

            UnitView* av = [UnitView createForUnit:[self attacker]];
            [av setPosition:[xformer hexCenterToScreen:[self defenderHex]]];
            [av addAnimation:aAnim forKey:@"position"];
        }

        [CATransaction commit];

    } else {
        [self endCombat:list];
    }
}

- (void)endCombat:(BAAAnimationList*)list {
    DEBUG_ANIMATION(@"running animation %@ (end)", self);
    [list run:nil];
}

@end

//==============================================================================
@implementation BAAAnimationListItemCombat

+ (id)itemWithAttacker:(BAUnit*)attacker
              defender:(BAUnit*)defender
             retreatTo:(HMHex)retreatHex
             advanceTo:(HMHex)advanceHex {
    BAAAnimationListItemCombat* o = [[BAAAnimationListItemCombat alloc] init];

    if (o) {
        [o setAttacker:attacker];
        [o setDefender:defender];
        [o setRetreatHex:retreatHex];
        [o setAdvanceHex:advanceHex];

        // attackerGunfire filled in later
        [o setAttackerHex:[attacker location]];
        [o setDefenderHex:[defender location]];
    }

    return o;
}

- (void)runWithParent:(BAAAnimationList*)list {
    DEBUG_ANIMATION(@"running animation %@ (gunfire)", self);

    HMCoordinateTransformer* xformer = [list xformer];

    [CATransaction begin];

    [CATransaction setCompletionBlock:^{
            [self showRetreatAndAdvance:list];
        } ];

    // Attacker animation computation
    CGPoint centerPt = [xformer hexCenterToScreen:[self attackerHex]];

    CAKeyframeAnimation* anim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    [anim setValues:@[
                      [NSValue valueWithCGPoint:centerPt],
                      [NSValue valueWithCGPoint:shiftPoint(centerPt, -5.0f, 0.0f)],
                      [NSValue valueWithCGPoint:centerPt],
                      [NSValue valueWithCGPoint:shiftPoint(centerPt, +5.0f, 0.0f)],
                      [NSValue valueWithCGPoint:centerPt]
                      ]
     ];
    [anim setKeyTimes:@[ @0.0f, @0.2f, @0.6f, @0.8f, @1.0f ]];
    [anim setDuration:SECONDS_PER_HEX_MOVE];

    UnitView* v = [UnitView createForUnit:[self attacker]];
    [v addAnimation:anim forKey:[[self attacker] name]];

    [CATransaction commit];

    int dirAToD = [[game board] directionFrom:[self attackerHex]
                                           to:[self defenderHex]];
    // 0 degrees longitude is straight to the right, but direction 0 in
    // HMHexMap terms is straight to the top.  So subtract 90 degrees from
    // the game logic angle to get the animation logic angle.
    CGFloat angleAToD = DEGREES_TO_RADIANS((dirAToD * 60) - 90);

    [self setAttackerGunfire:[BAAGunfire gunfireFrom:v withAzimuth:angleAToD]];
}

- (NSString*)description {
    return [NSString stringWithFormat:@"COMBAT attacker:%@ defender:%@ retreatHex:%02d%02d advanceHex:%02d%02d",
            [[self attacker] name],
            [[self defender] name],
            [self retreatHex].column,
            [self retreatHex].row,
            [self advanceHex].column,
            [self advanceHex].row
            ];
}

@end
